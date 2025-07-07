# 🍔 Meall

Um app iOS feito em **SwiftUI** com **Firebase**, onde usuários podem navegar por restaurantes, visualizar comidas e montar um carrinho para pedidos rápidos. Feito com foco em usabilidade, arquitetura limpa e componentes reativos.

---

## 🚀 Funcionalidades

- ✅ Autenticação com e-mail e senha (Firebase Auth)
- ✅ Criação de conta com validação de campos
- ✅ Listagem dinâmica de restaurantes e comidas (Firebase Firestore)
- ✅ Filtro de comidas por restaurante
- ✅ Detalhes de cada item com imagem e descrição
- ✅ Carrinho com quantidade e total dinâmico
- ✅ Toasts de feedback (sucesso / erro)
- ✅ Tela de perfil com opções de logout e deletar conta
- ✅ Testes unitários com mocks

---

## 📸 Preview

![image](https://github.com/user-attachments/assets/d1cdef12-113a-4958-a57a-7ffaf348a547)

---

## 🧑‍💻 Tecnologias Utilizadas

- **SwiftUI**
- **Firebase Auth & Firestore**
- **MVVM Architecture**
- **Combine / `@Published` bindings**
- **XCTest** para testes unitários

---

## 🧪 Testes

Testes com mocks para garantir que a lógica de negócios funciona isoladamente.

Exemplo de teste:
```swift
func testFetchFoodsLoadsCorrectData() {
    let viewModel = FoodViewModel(service: MockFoodService())
    viewModel.fetchFoods()
    XCTAssertEqual(viewModel.filteredFoods.count, 2)
}
```

---

## 📝 Pré-requisitos

- **Xcode 15 ou superior**
- **Swift 5.9+**
- **Firebase iOS SDK configurado**
- **Criar um arquivo GoogleService-Info.plist com suas credenciais**

---

## 🔧 Instalação

1. Clone este repositório:

```
git clone https://github.com/seuusuario/meall-app.git
```

2. Abra o projeto no Xcode:

```
open MeallApp.xcodeproj
```

3. Instale dependências se necessário (via Swift Package Manager)

4. Certifique-se de que o Firebase esteja corretamente configurado

5. Rode o app (Cmd + R)

---

## 🙋‍♂️ Autor

Marcus Titton

GitHub: @marcustitton

LinkedIn: linkedin.com/in/marcustitton



