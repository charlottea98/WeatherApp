//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Charlotte Andersson on 2023-11-26.
//

import SwiftUI

struct WeatherView: View {
    @State private var currentDate = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    var weather:ResponseBody
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                VStack (alignment: .leading,
                        spacing: 5){
                    Text(weather.name).bold().font(.title)
                    Text("Today, \(currentDate.formatted(.dateTime.month().day().hour().minute()))")
                                .onReceive(timer) { _ in
                                    currentDate = Date() // Update the date every minute
                                }
                }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                Spacer()
                VStack {
                    HStack{
                        VStack(spacing: 20){
                            Image(systemName: weatherIcon[weather.weather[0].main] ?? "sun.max").font(.system(size: 40))
                            Text(weather.weather[0].main)
                        }.frame(width: 150, alignment: .leading)
                        Spacer()
                        Text("\(weather.main.feels_like.roundDouble())°").font(.system(size: 90)).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).padding()
                    }
                    Spacer().frame(height: 80)
                    
                    AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2020/01/24/21/33/city-4791269_960_720.png")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Spacer()
                    
                    
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/ )
            }
            .padding()
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            
            VStack{
                Spacer()
                
                VStack (alignment: .leading, spacing: 20){
                    Text("Weather now:")
                        .bold().padding(.bottom)
                    
                    HStack{
                        WeatherRow(logo: "thermometer", name: "Min temp", value: "\(weather.main.temp_min.roundDouble())°")
                        Spacer()
                        WeatherRow(logo: "thermometer", name: "Max temp", value: "\(weather.main.temp_max.roundDouble())°")
                    }
                    HStack{
                        WeatherRow(logo: "wind", name: "Wind speed", value: "\(weather.wind.speed.roundDouble())m/s")
                        Spacer()
                        WeatherRow(logo: "humidity", name: "Humidity", value: "\(weather.main.humidity.roundDouble())%")
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding()
                .padding(.bottom, 20)
                .foregroundColor(Color(hue: 0.655, saturation: 0.787, brightness: 0.354))
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    WeatherView(weather: previewWeather)
}
