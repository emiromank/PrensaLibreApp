//
//  ContentView.swift
//  PrensaL
//
//  Created by emilianoramon on 14/04/24.
//

import SwiftUI
import CoreData
import LocalAuthentication
import MapKit
import SwiftUI
import CoreLocation
import PhotosUI
import Security

struct ContentView: View {
    @State var text = "LOCKED"
    
    var body: some View {
        VStack {
            if text == "LOCKED" {
                Login(text: $text)
            }
            else if text == "UNLOCKED" {
                Menu(text: $text)
                
            }
            else if text == "SEED" {
                Seed(text: $text)
            }
            else if text == "EMERGENCY" {
                EmergencyButton(text: $text)
            }
            else if text == "HASH"{
                UploadPicAndGetHash(text: $text)
            }
            else if text == "REPORTS" {
                ReportsView(text: $text)
            }
            else if text == "CONTACTS" {
                ContactsView(text: $text)
            }
            else if text == "ENCRYPT" {
                EncryptText(text: $text)
            }
        }
    }
    
    struct Login: View {
        @Binding var text: String
        @State private var username: String = ""
        @State private var password: String = ""
        
        func authenticate(){
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Authenticate with Face ID"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            text = "UNLOCKED"
                        } else {
                            text = "LOCKED"
                        }
                    }
                }
            } else {
                text = "UNAVAILABLE"
            }
        }
        
        var body: some View {
            VStack {
                Image(systemName:"newspaper")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                Text("Prensa Libre")
                    .font(.title)
                    .padding()
                    .scaleEffect(2.0)
                
                TextField("Usuario", text: $username)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Contraseña", text: $password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    if username == "Admin" && password == "Password" {
                        text = "UNLOCKED"
                    } else {
                        text = "LOCKED"
                    }
                }) {
                    Text("Login")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    authenticate()
                }) {
                    Text("Login con Face ID")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
                
                Button(action: {
                    // Perform Seed login logic here
                    text = "SEED"
                }) {
                    Text("Login con frase")
                        .font(.headline)
                        .foregroundColor(.red)
                        .underline()
                }
                
            }
            .padding()
        }
    }
    
    
    
    struct Seed: View {
        @Binding var text: String
        @State private var seed: String = ""
        
        var body: some View {
            VStack {
                Image(systemName:"externaldrive.fill.trianglebadge.exclamationmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                Text("Login con frase")
                    .font(.largeTitle)
                    .padding()
                
                TextField("Seed Phrase", text: $seed)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    if seed == "seed-phrase"{
                        text = "UNLOCKED"
                    } else {
                        text = "SEED"
                    }
                }) {
                    Text("Login with Seed Phrase")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
    struct Menu: View {
        @Binding var text: String
        var body: some View {
            
            VStack {
                Image(systemName:"person.badge.key.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                Text("Menú")
                    .font(.largeTitle)
                    .padding()
                
                List {
                    Button(action: {
                        text = "EMERGENCY"
                    }) {
                        Text("Botón de Emergencia")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        text="HASH"
                    }) {
                        Text("Hash evidencia")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                       text="ENCRYPT"
                    }) {
                        Text("Mensajería Segura")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        text = "REPORTS"
                    }) {
                        Text("Reportes anónimos")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        text = "CONTACTS"
                    }) {
                        Text("Contactos de emergencia")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    struct EmergencyButton: View {
        @Binding var text: String
        @State private var inputText: String = ""
        @State private var showAlert = false
        
        let locationManager = CLLocationManager()
        
        @State var region = MKCoordinateRegion(
            center: .init(latitude: 19.425,longitude: -99.167),
            span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        var body: some View {
            ZStack {
                Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        locationManager.requestWhenInUseAuthorization()
                    }
                VStack {
                    Image(systemName:"exclamationmark.triangle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    
                    Text("Botón de Emergencia")
                        .font(.largeTitle)
                        .padding()
                    
                    Spacer().frame(height: 20)
                    Spacer()
                    
                    TextEditor(text: $inputText)
                        .frame(height: 100)
                        .padding()
                        .border(Color.gray, width: 0.5)
                    
                    
                    
                    
                    
                    Button(action: {
                        showAlert = true
                    }) {
                        Text("Emergencia")
                            .padding(10)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .scaleEffect(1)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Éxito!"),
                            message: Text("Emergercia Reportada"),
                            dismissButton: .default(Text("OK")) {
                                text="UNLOCKED"
                            }
                        )
                    }
                }
            }}
    }
    
    
    struct UploadPicAndGetHash: View {
        @Binding var text: String
        @State private var isImagePickerDisplayed = false
        @State private var selectedImage: UIImage?
        @State private var inputText: String = ""
        @State private var showAlert = false
        @State private var hash = ""
        @State private var avatarItem: PhotosPickerItem?
        @State private var avatarImage: Image?
        
        var body: some View {
            VStack {
                Image(systemName:"lock.icloud.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                Text("Subir imagen y obtener hash")
                    .font(.largeTitle)
                    .padding()
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                
                PhotosPicker("Seleccionar Imagen", selection: $avatarItem, matching: .images)
                
                avatarImage?
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                
                Spacer(minLength: 20)
                Button(action: {
                    showAlert = true
                    
                }) {
                    Text("Upload")
                        .padding(20)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .scaleEffect(1.5)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Listo!"),
                        message: Text("Guardado. Hash: \(hash)"),
                        dismissButton: .default(Text("OK")) {
                            text="UNLOCKED"
                        }
                    )
                }
                Text("Hash: \(hash)")
                    .padding()
                
            }
            .onChange(of: avatarItem) {
                Task {
                    if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
                        avatarImage = loaded
                        hash = "be254d0808a7d00714b83220fb9a78ae"
                    } else {
                        print("Failed")
                    }
                }
            }
            
            
        }}
    
    struct Report: Identifiable {
        let id = UUID()
        let name: String
        let description: String
    }
    
    struct ReportsView: View {
        @Binding var text: String
        // Sample data
        let reports = [
            Report(name: "Robo en la calle", description: "Reportan haber sido víctima de un robo a mano armada en la calle principal de la colonia Juárez."),
            Report(name: "Vandalismo en el parque", description: "Se observaron varios individuos causando daños en bancas y juegos infantiles del parque México durante la noche."),
            Report(name: "Accidente de tráfico", description: "Se produjo una colisión entre dos vehículos en el cruce de Insurgentes y Reforma, con daños materiales y heridos leves."),
            Report(name: "Venta de drogas", description: "Se sospecha de una casa en la calle Zaragoza como punto de venta de drogas, con movimiento constante de personas de aspecto sospechoso."),
            Report(name: "Ruido excesivo", description: "Vecinos reportan constantes fiestas con música a alto volumen en un departamento de la calle Durango, perturbando la tranquilidad del vecindario."),
            Report(name: "Acoso callejero", description: "Una joven fue acosada verbalmente por un hombre en la estación del metro Insurgentes, sintiéndose amenazada y asustada."),
            Report(name: "Incendio en fábrica abandonada", description: "Se observa humo y llamas provenientes de una fábrica abandonada en la colonia Roma, generando preocupación por posibles riesgos para la comunidad."),
            Report(name: "Animales abandonados", description: "Un grupo de perros callejeros ha sido visto merodeando por las calles de la colonia Condesa, preocupando a los residentes por su bienestar."),
        ]
        
        
        var body: some View {

            Text("Reportes Anónimos")
                .font(.largeTitle)
                .padding()
            List(reports) { report in
                VStack(alignment: .leading) {
                    Text(report.name)
                        .font(.headline)
                    Text(report.description)
                        .font(.subheadline)
                }
                .padding(.vertical)
            }
            .navigationTitle("Reports")
            
            Button(action: {
                text = "UNLOCKED"
            }) {
                Text("Volver")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
        }
    }
    
    struct Contact: Identifiable {
        let id = UUID()
        let name: String
        let phoneNumber: String
    }
    
    struct ContactsView: View {
        @Binding var text: String
@State private var contacts: [Contact] = [
    Contact(name: "Juan Pérez", phoneNumber: "55-1234-5678"),
    Contact(name: "María García", phoneNumber: "55-8765-4321"),
    Contact(name: "Roberto López", phoneNumber: "55-1111-2222"),
]
        @State private var showingAddContact = false
        @State private var newContactName = ""
        @State private var newContactPhoneNumber = ""
        
        var body: some View {
            VStack {
                Image(systemName:"person.crop.circle.badge.checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                Text("Contactos de Emergencia")
                    .font(.largeTitle)
                    .padding()
                List(contacts) { contact in
                    VStack(alignment: .leading) {
                        Text(contact.name)
                            .font(.headline)
                        Text(contact.phoneNumber)
                            .font(.subheadline)
                    }
                    .padding(.vertical)
                }
                .navigationTitle("Emergency Contacts")
                
                Button(action: {
                    showingAddContact = true
                }) {
                    Text("Agregar contacto")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                        Button(action: {
                text = "UNLOCKED"
            }) {
                Text("Volver")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            }
            .sheet(isPresented: $showingAddContact) {
                VStack {
                    TextField("Nombre", text: $newContactName)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    TextField("Teléfono", text: $newContactPhoneNumber)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    Button(action: {
                        let newContact = Contact(name: newContactName, phoneNumber: newContactPhoneNumber)
                        contacts.append(newContact)
                        newContactName = ""
                        newContactPhoneNumber = ""
                        showingAddContact = false
                    }) {
                        Text("Agregar")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
        }
    }}


struct EncryptText: View {
    @Binding var text: String
    @State private var textEn = ""
    @State private var base64String=""

    var body: some View {
        VStack {
            Image(systemName:"lock.doc.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            Text("Mensajería Encriptada")
                .font(.largeTitle)
                .padding()
            TextField("Text", text: $textEn)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            Button(action: {
                if let data = textEn.data(using: .utf8) {
                base64String = data.base64EncodedString()
                }
            }) {
                Text("Enviar mensaje")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Spacer(minLength: 5)
            Text("Mensaje Enviado:" + base64String)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            
            Button(action: {
                    text = "UNLOCKED"
                }) {
                    Text("Volver")
                }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }


}
  
#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}


