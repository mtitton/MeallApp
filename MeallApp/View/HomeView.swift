//
//  HomeView.swift
//  MeallApp
//
//  Created by Marcus Titton on 03/07/25.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var filterViewModel: FilterViewModel
    @EnvironmentObject var feedbackViewModel: FeedbackViewModel

    var body: some View {
        VStack {
            AppBarView()
            
            ScrollView {
                RestaurantsListView()
                FoodListView()
                    .environmentObject(cartViewModel)
                
                Spacer()
            }
            
            BottomTabBar()
                .environmentObject(router)
                .environmentObject(cartViewModel)
        }
        .accentColor(nil)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct BottomTabBar: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var cartViewModel: CartViewModel

    let icons: [String] = ["home2", "heart", "bell", "cart2"]

    var body: some View {
        HStack(spacing: 70) {
            ForEach(icons, id: \.self) { icon in
                Button(action: {
                    withAnimation(.spring()) {
                        if router.currentTab != icon {
                            router.currentTab = icon

                            switch icon {
                            case "cart2":
                                router.navigate(to: .cart)
                            case "home2":
                                router.navigate(to: .home)
                            case "heart":
                                // router.navigate(to: .favorites) — se tiver
                                break
                            case "bell":
                                // router.navigate(to: .notifications) — se tiver
                                break
                            default:
                                break
                            }
                        }
                    }
                }) {
                    ZStack(alignment: .topTrailing) {
                        Image(icon)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(router.currentTab == icon ? Color("blue") : .gray)

                        if icon == "cart2" && totalItemsInCart > 0 {
                            Text("\(totalItemsInCart)")
                                .font(.caption2)
                                .foregroundColor(.white)
                                .frame(width: 16, height: 16)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 10, y: -10)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
    }

    private var totalItemsInCart: Int {
        cartViewModel.items.reduce(0) { $0 + $1.quantity }
    }
}


struct AppBarView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        
        HStack(spacing: 50) {
            
            Image(systemName: "circle.grid.2x2")
                .foregroundStyle(.blue)
                .padding()
                .background(Color(.blue).opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            HStack {
                
                Image("mapmaker")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.blue)
                
                Text("Santo André, SP")
                    .bold()
            }
            
            profile
        }
        .padding()
    }
    
    private var profile: some View {
        Button {
            router.navigate(to: .profile)
        } label: {
            if let user = authViewModel.currentUser {
                Text(user.initials)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .frame(width: 50, height: 50)
                    .background(Color(.lightBlue))
                    .clipShape(Circle())
            } else {
                Image("profile")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            }
        }
    }
}

struct RestaurantsListView: View {

    @StateObject private var viewModel = RestaurantViewModel()
    @EnvironmentObject var filterViewModel: FilterViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Restaurantes")
                .font(.system(size: 25))
                .bold()

            ScrollView(.horizontal,showsIndicators: false) {
                HStack {
                    ForEach(viewModel.restaurants) { restaurant in
                        let isSelected = filterViewModel.selectedRestaurantName == restaurant.restaurant

                        HStack(spacing: 10) {
                            Image(restaurant.imagePath)
                                .resizable()
                                .frame(width: 20, height: 20)

                            Text(restaurant.restaurant)
                                .foregroundStyle(isSelected ? .white : .black)
                                .font(isSelected ? .headline : .callout)
                        }
                        .padding()
                        .background(isSelected ? Color.blue : Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                filterViewModel.selectedRestaurantName = isSelected ? nil : restaurant.restaurant
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchRestaurants()
        }
    }
}

struct FoodListView: View {

    @StateObject private var viewModel = FoodViewModel()
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var filterViewModel: FilterViewModel

    var body: some View {
        VStack {
            HStack {
                Text("Itens")
                    .font(.system(size: 25))
                    .bold()
                Spacer()
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.filteredFoods) { food in
                        NavigationLink(destination: FoodDetailsView(food: food)) {
                            VStack {
                                Image(food.imagePath)
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 150, height: 150)

                                Text(food.name)
                                    .bold()

                                Text(food.subtitle)
                                    .font(.subheadline)

                                HStack {
                                    Text("R$")
                                        .bold()
                                        .font(.body)
                                        .foregroundStyle(.blue)

                                    Text(String(food.price))
                                        .bold()
                                        .font(.title)
                                }
                            }
                            .padding()
                            .frame(width: 200, height: 250)
                            .background(Color.gray.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.trailing, 10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.fetchFoods(filteredBy: filterViewModel.selectedRestaurantName)
        }
        .onChange(of: filterViewModel.selectedRestaurantName) { newValue in
            viewModel.filterFoods(byRestaurantName: newValue)
        }
    }
}

#Preview {
    HomeView()
}
