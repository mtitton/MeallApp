//
//  FoodDetailsView.swift
//  MeallApp
//
//  Created by Marcus Titton on 03/07/25.
//

import SwiftUI

struct FoodDetailsView: View {
 
    var food: Food
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var feedbackViewModel: FeedbackViewModel
    
    var body: some View {
        
        ZStack {
            Color(.lightBlue)
                .ignoresSafeArea(.all)
            
            VStack {
                AppbarView()
                    .padding(.top)
                
                FoodCardContent(food: self.food)
            }
            .padding(.horizontal)
            
            
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
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct AppbarView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        HStack {
            Button(action: {
                dismiss()
            })
            {
                Image(systemName: "arrow.left")
                    .foregroundStyle(.blue)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
            Spacer()
        }
    }
}

struct FoodCardContent: View {
        
    var food: Food
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var feedbackViewModel: FeedbackViewModel
    @State var countrt: Int = 1
    
    var body: some View {
        
        GeometryReader { proxy in
            VStack(spacing: 15) {
                Image(food.imagePath)
                    .resizable()
                    .frame(width: 230, height: 230)
                
                HStack(spacing: 30) {
                    Text("-")
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                        .onTapGesture {
                            (self.countrt > 1) ?  (self.countrt-=1) : (self.countrt = 0)
                    }
                    
                    Text(String(self.countrt))
                        .foregroundStyle(.white)
                        .font(.body)
                        .bold()
                    
                    Text("+")
                        .foregroundStyle(.white)
                        .font(.body)
                        .bold()
                        .onTapGesture {
                            (self.countrt < 20) ?  (self.countrt+=1) : (self.countrt = 20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                
                HStack(alignment: .center) {
                    VStack(alignment:.leading) {
                        
                        Text(food.name)
                            .font(.title2)
                            .bold()
                        
                        Text(food.subtitle)
                            .foregroundStyle(.gray)
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("R$")
                            .font(.body)
                            .bold()
                            .foregroundStyle(.blue)
                        
                        Text(String(food.price))
                            .font(.title)
                            .bold()
                    }
                }
                
                Spacer()
                
                HStack {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        
                        Text("4,8")
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    HStack{
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.orange)
                        
                        Text("150 Kcal")
                            .foregroundStyle(.black)
                            .font(.subheadline)
                            .bold()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "timer")
                            .foregroundStyle(.red)
                        
                        Text("5-10 Min")
                            .foregroundStyle(.black)
                            .font(.subheadline)
                            .bold()
                    }
                }
                
                Spacer()
                
                Text(food.description)
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                
                Spacer()

                Button(action: {
                    cartViewModel.addToCart(food, quantity: self.countrt)
                    feedbackViewModel.show(message: "Produto adicionado ao carrinho!")
                }) {
                    Text("Comprar")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .bold()
                        .padding(.horizontal, 120)
                        .padding(.vertical, 20)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .padding()
                
                Spacer()
            }
            .padding(.vertical)
            .background(
                VStack {
                    Color.white
                        .frame(width: proxy.size.width * 1.1)
                }
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .padding(.top,120)
             
            )
            .ignoresSafeArea(.all)
        }
    }
}
