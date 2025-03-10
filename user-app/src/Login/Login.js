import React, { useState } from "react";
import { loginUsuario } from "../api"; // Importa la función de la API
import "./Login.css"; // Importa el archivo CSS

const Login = ({ setUsuario }) => {
  const [correo, setCorreo] = useState("");
  const [contraseña, setContraseña] = useState("");
  const [mensaje, setMensaje] = useState("");

  const manejarLogin = async (e) => {
    e.preventDefault();

    const credenciales = { CorreoElectronico: correo, Contraseña: contraseña };
    const respuesta = await loginUsuario(credenciales);

    if (respuesta.success) {
      setMensaje("Inicio de sesión exitoso");
      localStorage.setItem("usuario", JSON.stringify(respuesta.data)); 
      setUsuario(respuesta.data); 
    } else {
      setMensaje(respuesta.message);
    }
  };

  return (
    <div className="login-container">
      <form className="login-form" onSubmit={manejarLogin}>
        <h2 className="login-titulo">Iniciar sesión</h2>
        <input
          type="email"
          placeholder="Correo"
          value={correo}
          onChange={(e) => setCorreo(e.target.value)}
          className="login-input"
        />
        <input
          type="password"
          placeholder="Contraseña"
          value={contraseña}
          onChange={(e) => setContraseña(e.target.value)}
          className="login-input"
        />
        <button type="submit" className="login-button">
          Ingresar
        </button>
      </form>
      {mensaje && <div className="login-mensaje">{mensaje}</div>}
    </div>
  );
};

export default Login;