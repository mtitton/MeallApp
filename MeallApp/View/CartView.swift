//
//  CartView.swift
//  MeallApp
//
//  Created by Marcus Titton on 04/07/25.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var feedbackViewModel: FeedbackViewModel

    var body: some View {
        VStack(alignment: .leading) {
            if cartViewModel.items.isEmpty {
                Spacer()
                Text("Seu carrinho está vazio")
                    .foregroundStyle(.gray)
                    .font(.title3)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                Spacer()
            } else {
                List {
                    ForEach(cartViewModel.items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.food.name)
                                    .font(.headline)

                                Text("R$ \(item.food.price * Double(item.quantity), specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }

                            Spacer()

                            HStack(spacing: 10) {
                                // Botão de diminuir
                                Button(action: {
                                    cartViewModel.decreaseQuantity(for: item.food)

                                    if let updatedItem = cartViewModel.items.first(where: { $0.food.id == item.food.id }) {
                                        if updatedItem.quantity == 0 {
                                            feedbackViewModel.show(message: "Item removido do carrinho")
                                        }
                                    } else {
                                        feedbackViewModel.show(message: "Item removido do carrinho")
                                    }
                                }) {
                                    Image(systemName: "minus.circle")
                                        .font(.title3)
                                }

                                Text("\(item.quantity)")
                                    .frame(minWidth: 24)

                                // Botão de aumentar
                                Button(action: {
                                    cartViewModel.addToCart(item.food)
                                }) {
                                    Image(systemName: "plus.circle")
                                        .font(.title3)
                                }
                            }
                            .buttonStyle(.borderless) // evita conflito com o List
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        indexSet.map { cartViewModel.items[$0] }.forEach {
                            cartViewModel.removeFromCart($0)
                        }
                    }
                }

                HStack {
                    Text("Total:")
                        .bold()
                    Spacer()
                    Text("R$ \(cartViewModel.total, specifier: "%.2f")")
                        .bold()
                }
                .padding()
            }
        }
        .navigationTitle("Carrinho")
        .onDisappear {
            router.currentTab = "home2"
        }
        .overlay() {
            if feedbackViewModel.isVisible {
                VStack {
                    Spacer()
                    ToastView(message: feedbackViewModel.message, isError: feedbackViewModel.isError)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: feedbackViewModel.isVisible)
                        .padding(.bottom, 40)
                }
            }
        }
    }
}
