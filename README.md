# 📱 Promoradar

**Promoradar** es una aplicación móvil hecha en **Flutter** que centraliza y organiza promociones bancarias y de billeteras virtuales en un solo lugar.  
La idea es que cada usuario seleccione sus bancos / billeteras y pueda ver únicamente las promos que realmente le aplican, con filtros por categorías y una interfaz simple y moderna. 🚀

---

## ✨ Features

- 🔐 Selección de bancos y billeteras 
- 🛒 Filtros por categorías: supermercados, restaurantes, cines, electrónica.
- 📰 Catálogo de promociones actualizado (prototipo con JSON local, escalable a APIs reales).
- ⭐️ Vista detallada de cada promoción con condiciones, vigencia y botón de compartir.
- 🎨 UI moderna con Material Design 3 y soporte para dark mode.
- ⚡️ Arquitectura con Provider para estado global y fácil escalabilidad.

---

## 🏗️ Arquitectura

- **Flutter** + **Dart** (cross-platform).
- **Provider** para gestión de estado (promos y preferencias de usuario).
- **Assets locales (JSON)** → mock de promociones (se reemplazará por APIs reales en futuro).
- Estructura modular:
  - `/models` → modelos de datos 
  - `/providers` → lógica de estado
  - `/screens` → pantallas 
  - `/widgets` → componentes reutilizables 
  - `/assets` → JSON de prueba + imágenes/logos.

---

## 🗂️ Roadmap

- [x] Estructura inicial con navegación **Home / Search / Profile**  
- [x] Gestión de estado con **Provider**  
- [x] Promos mockeadas desde **JSON local**  
- [x] Filtros por **banco** y **categorías**  
- [x] Pantalla de **detalle de promo** con botón de compartir  
- [ ] Guardar **favoritos** de usuario (promos destacadas ⭐️)  
- [ ] **Notificaciones** locales / push  
- [ ] Conexión con **base de datos**
- [ ] Agregar **login** de usuario
- [ ] **Onboarding inicial** para elegir bancos al primer inicio 
- [ ] Integrar **APIs reales** de bancos y billeteras   
- [ ] Publicación en **Play Store / App Store**

---

## 🚀 Instalación

Cloná el repo y corré el proyecto en tu emulador o dispositivo:

```bash
# clonar repo
git clone https://github.com/moreescudero/promoradar.git
cd promoradar

# instalar dependencias
flutter pub get

# correr en dispositivo/emulador
flutter run
