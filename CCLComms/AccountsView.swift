//
//  PrefsView.swift
//  CCLComms
//
//  Created by Felipe on 6/30/22.
//

import SwiftUI

struct AccountSummaryModel {
    var charges: String = "$0.0"
    var credits: String = "$0.0"
    var total: String = "$0.0"
    var ccpaid: String = ""
}

enum TransactionType {
    case credit
    case debit
}

struct Itinerary: Hashable, Identifiable {
    var id = UUID().uuidString
    var day: String
    var description: String
    
    static var mock: [Itinerary] = [
        Itinerary(day: "Sunday, April 17", description: "Miami, Florida"),
        Itinerary(day: "Monday, April 18", description: "Nassau, Bahamas"),
    ]
}

struct Transaction: Hashable, Identifiable {
    var id = UUID().uuidString
    var top: String = ""
    var bottom: String = ""
    var amount: String = "$0.00"
    var type: TransactionType = .debit
    var date: Date = Date()
    var itinerary: Itinerary
    
    func matches(tag: Int) -> Bool {
        if tag == 0 {
            return true
        }
        if tag == 1 && type == .debit {
            return true
        }
        if tag == 2 && type == .credit {
            return true
        }
        return false
    }
    
    static var mock: [Transaction] = [
        Transaction(top: "Bonsai Sushi", bottom: "by Jeremy", amount: "$29.15", itinerary: Itinerary.mock.first!),
        Transaction(top: "Cash Deposit", bottom: "by Jeremy", amount: "$100.00", type: .credit, itinerary: Itinerary.mock.first!),
        Transaction(top: "Pizzeria el Capitano", bottom: "by Theresa", amount: "$29.15", itinerary: Itinerary.mock.first!),
        Transaction(top: "Green Eggs & Ham Breakfast", bottom: "by Theresa", amount: "$15.20", itinerary: Itinerary.mock.first!),
        Transaction(top: "Casino Night Club", bottom: "by Theresa", amount: "$210.00", itinerary: Itinerary.mock.first!),
        
        Transaction(top: "Bonsai Sushi", bottom: "by Jeremy", amount: "$29.15", itinerary: Itinerary.mock.last!),
        Transaction(top: "Cash Deposit", bottom: "by Jeremy", amount: "$100.00", type: .credit, itinerary: Itinerary.mock.last!),
        Transaction(top: "Pizzeria el Capitano", bottom: "by Theresa", amount: "$29.15", itinerary: Itinerary.mock.last!),
        Transaction(top: "Green Eggs & Ham Breakfast", bottom: "by Theresa", amount: "$15.20", itinerary: Itinerary.mock.last!),
        Transaction(top: "Casino Night Club", bottom: "by Theresa", amount: "$210.00", itinerary: Itinerary.mock.last!),
    ]
}

class AccountViewModel: ObservableObject {
    @Published var summary: AccountSummaryModel
    @Published var charges: [Transaction]
    @Published var itinerary: [Itinerary]
    
    init(summary: AccountSummaryModel, charges: [Transaction], itinerary: [Itinerary]) {
        self.summary = summary
        self.charges = charges
        self.itinerary = itinerary
    }
    
    func addCharge(_ charge: Transaction) {
        charges.append(charge)
        let charges = Double(summary.charges.dropFirst())
        let newCharge = Double(charge.amount.dropFirst())
        let newCharges = (charges ?? 0.0) + (newCharge ?? 0.0)
        summary.charges = "$\(newCharges.rounded())"
        let credits = Double(summary.credits.dropFirst())
        let total = newCharges - (credits ?? 0.0)
        summary.total = "$\(total.rounded())"
    }
    
    func charges(for day: Itinerary, tag: Int) -> [Transaction] {
        charges.filter({$0.itinerary == day && $0.matches(tag: tag)}).sorted(by: { l, r in
            l.date > r.date
        })
    }
}

struct AccountSummaryView : View {
    @ObservedObject var vm: AccountViewModel

    var body: some View {
        VStack() {
            HStack {
                Text("Account Summary")
                    .cclFont(name:.openSansBold, size: 24, color: .blue)
                Spacer()
            }
            .padding(.bottom)
            
            HStack {
                Text("Charges")
                Spacer()
                Text(vm.summary.charges)
                    .foregroundColor(.black)
            }
            .padding(.bottom, 2.0)
            .foregroundColor(.gray)
            
            HStack {
                Text("Credits")
                Spacer()
                Text(vm.summary.credits)
                    .foregroundColor(.black)
            }
            .foregroundColor(.gray)
            
            Divider()
            
            HStack {
                Text("Settled To")
                    .foregroundColor(.black)
                    .bold()
                Spacer()
            }
            
            HStack {
                Text(vm.summary.ccpaid)
                Spacer()
                Text(vm.summary.total)
                    .font(.title3)
                    .fontWeight(.black)
                    .foregroundColor(Color.black)
                    .bold()
            }
            .foregroundColor(.gray)
            
            Divider()
            
            Button {
                vm.addCharge(Transaction(top: "Pizzeria el Capitano", bottom: "by Theresa", amount: "$29.15", itinerary: Itinerary.mock.first!))
            } label: {
                Text("Manage Preferences")
                    .cclFont(name:.openSansBold, size: 20)
                    .frame(width: 300.0, height: 50)
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 3)
                    .cornerRadius(5.0)
            }
        }
        .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
        .background(.white)
    }
}

struct AccountsView: View {
    @State private var isLoading = false
    @ObservedObject var vm: AccountViewModel
    @State var selection = 0
    
    var body: some View {
        ScrollView {
            AccountSummaryView(vm: vm)
            
            Picker("", selection: $selection) {
                Text("All").tag(0)
                Text("Charges").tag(1)
                Text("Credits").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.vertical)
            
            ForEach(vm.itinerary) { day in
                Section {
                    ForEach(vm.charges(for: day, tag: selection), id:\.id) { tx in
                        TransactionView(tx: tx)
                    }
                } header: {
                    VStack(alignment: .leading, spacing: 10.0) {
                        HStack {
                            Text(day.day)
                                .bold()
                            Spacer()
                        }
                        HStack {
                            Text(day.description)
                                .font(.title3)
                        }
                    }
                }
            }
        }
        .padding(10)
        .background(Color(hue: 1.0, saturation: 0.013, brightness: 0.891))
    }
    
    private var starOverlay: some View {
        Image(systemName: "star")
            .padding([.top, .trailing], 5)
    }
    
    @ViewBuilder private var loadingOverlay: some View {
        if isLoading {
            ProgressView()
        }
    }
}

/// Cell View
struct TransactionView: View {
    var tx: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(tx.top)
                    .cclFont(name: .openSansSemiBold, size: 16, color: .blue)
                Spacer()
                Text(tx.bottom)
                    .cclFont(name: .openSansRegular, size: 14, color: .gray)
            }
            Spacer()
            VStack(alignment: .trailing) {
                HStack {
                    Text(tx.amount)
                        .font(.title3)
                        .bold()
                        .foregroundColor(tx.type == .credit ? .green : .gray)
                    Image(systemName: "greaterthan.circle")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
        .padding(.horizontal, 10.0)
        .background(.white)
    }
}

struct PrefsView_Previews: PreviewProvider {
    static var vm = AccountViewModel(summary: AccountSummaryModel(charges: "$288.46", credits: "$200.00", total: "$88.46", ccpaid: "Mastercard ..5678"), charges: Transaction.mock, itinerary: Itinerary.mock)
    static var previews: some View {
        AccountsView(vm: vm)
    }
}

/// Custom CCLFont Modifier

@available(iOS 13, *)

extension View {
    func cclFont(name: CCLFont, size: Double, color: Color? = .black) -> some View {
        return self.modifier(ScaledFont(name: name.name, size: size, color: color))
    }
}

struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var name: String
    var size: Double
    var color: Color?
    
    func body(content: Content) -> some View {
       let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return content.font(.custom(name, size: scaledSize)).foregroundColor(color)
    }
}
