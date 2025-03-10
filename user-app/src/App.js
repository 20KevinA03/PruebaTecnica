import React, { useState, useEffect } from "react";
import "./App.css";
import UserList from "./GestionUsuarios/UserList";
import Header from "./GestionUsuarios/Header";
import Login from "./Login/Login";

function App() {
  const [usuario, setUsuario] = useState(null);

  useEffect(() => {
    // Verificar si hay un usuario en localStorage
    const usuarioGuardado = localStorage.getItem("usuario");
    if (usuarioGuardado) {
      setUsuario(JSON.parse(usuarioGuardado)); // Cargar usuario desde localStorage
    }
  }, []);

  return (
    <div>
      {usuario ? (
        <>
          <Header />
          <UserList />
        </>
      ) : (
        <Login setUsuario={setUsuario} />
      )}
    </div>
  );
}

export default App;
