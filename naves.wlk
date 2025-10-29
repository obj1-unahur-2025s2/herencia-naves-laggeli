class Nave {
  var property velocidad
  var property dirección
  var property combustible
  method acelerar(unaVelocidad) { velocidad = (velocidad + unaVelocidad).min(100000) }
  method desacelerar(unaVelocidad) { velocidad = (velocidad - unaVelocidad).max(0) }
  method irHaciaElSol() { dirección = 10 }
  method escaparDelSol() { dirección = -10 }
  method ponerseParaleloAlSol() { dirección = 0 }
  method acercarseUnPocoAlSol() { dirección = (dirección + 1).min(10) }
  method alejarseUnPocoDelSol() { dirección = (dirección - 1).max(-10) }
  method cargarCombustible(cantidad) { combustible += cantidad }
  method descargarCombustible(cantidad) { combustible = (combustible - cantidad).max(0) }
  method prepararViaje() { 
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }
  method estáTranquila() = combustible >= 4000 and velocidad <= 12000
  method escapar()
  method avisar()
  method recibirAmenaza() {
    self.escapar()
    self.avisar()
  }
  method estáDeRelajo() = self.estáTranquila()
  method initialize() {
    if (velocidad < 0) {self.error("La velocidad no puede ser menor a 0")}
    if (dirección < -10) {self.error("La dirección no puede ser menor a -10")}
    if (combustible < 0) {self.error("El combustible no puede ser menor a 0")}
  }
}

class NaveBaliza inherits Nave {
  var property balizaDeColor
  var vecesQueCambióLaBaliza = 0
  method balizaDeColor() = balizaDeColor
  method cambiarColorDeBaliza(colorNuevo) { 
    balizaDeColor = colorNuevo
    vecesQueCambióLaBaliza += 1
  } 
  override method prepararViaje() {
    super()
    self.cambiarColorDeBaliza("Verde")
    self.ponerseParaleloAlSol()
  }
  override method estáTranquila() = super() and balizaDeColor != "Rojo"
  override method escapar() { self.irHaciaElSol() }
  override method avisar() { balizaDeColor = "Rojo" }
  override method estáDeRelajo() = super() and self.tenerPocaActividad()
  method tenerPocaActividad() = vecesQueCambióLaBaliza == 0
}

class NavePasajeros inherits Nave {
  const pasajeros
  var property racionesDeComida = 0
  var property racionesDeBebida = 0
  method cargarComida(racion) { racionesDeComida += racion }
  method descargarComida(racion) { racionesDeComida = (racionesDeComida - racion).max(0) }
  method cargarBebida(racion) { racionesDeBebida += racion }
  method descargarBebida(racion) { racionesDeBebida = (racionesDeBebida - racion).max(0) }
  override method prepararViaje() {
    super()
    self.cargarComida(pasajeros * 4)
    self.cargarBebida(pasajeros * 6)
    self.acercarseUnPocoAlSol()
  }
  override method escapar() { velocidad = velocidad * 2 }
  override method avisar() { 
    self.descargarComida(pasajeros)
    self.descargarBebida(pasajeros * 2) 
  }
  override method estáDeRelajo() = super() and self.tenerPocaActividad()
  method tenerPocaActividad() = racionesDeComida < 50
}

class NaveHospital inherits NavePasajeros {
  var property tieneQuirófanosPreparados
  override method estáTranquila() = super() and !tieneQuirófanosPreparados
  override method recibirAmenaza() { 
    super() 
    tieneQuirófanosPreparados = true 
  }
}

class NaveCombate inherits Nave {
  var estáVisible
  const misiles = []
  const mensajes = []
  method agregarMisil(misil) { misiles.add(misil) }
  method sacarMisil(misil) { misiles.remove(misil) }
  method ponerseVisible() { estáVisible = true }
  method ponerseInvisible() { estáVisible = false }
  method estáInvisible() = !estáVisible
  method desplegarMisiles() { misiles.forEach({m => m.estáDesplegado(true)}) }
  method replegarMisiles() { misiles.forEach({m => m.estáDesplegado(false)}) }
  method misilesDesplegados() = misiles.filter({m => m.estáDesplegado()})
  method emitirMensaje(mensaje) { mensajes.add(mensaje) }
  method mensajesEmitidos() = mensajes
  method primerMensajeEmitido() = mensajes.first()
  method últimoMensajeEmitido() = mensajes.last()
  method esEscueta() = mensajes.all({m => m.size() < 31})
  method emitioMensaje(mensaje) = mensajes.contains(mensaje)
  method noHayDesplegados() = misiles.all({m => !m.estáDesplegado()})
  method todosLosMisilesEstánDesplegados() = misiles.all({m => m.estáDesplegado()})
  override method prepararViaje() {
    super()
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en misión")
  }
  override method estáTranquila() = super() and self.noHayDesplegados()
  override method escapar() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }
  override method avisar() { self.emitirMensaje("Amenaza recibida") }
}

class NaveCombateSigilosa inherits NaveCombate {
  override method estáTranquila() = super() and estáVisible
  override method recibirAmenaza() { 
    super() 
    self.desplegarMisiles()
    self.ponerseInvisible()
  }
}

class Misil {
  var property estáDesplegado 
}