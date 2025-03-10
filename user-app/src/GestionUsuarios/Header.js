import React from "react";

import "./Header.css";

const Header = () => {
  
  const usuario = JSON.parse(localStorage.getItem("usuario"));

  const manejarLogout = () => {
    localStorage.removeItem("usuario"); // Eliminar usuario del almacenamiento
    window.location.reload(); // Recargar la página completamente
  };

  return (
    <div>
    <header className="header">
      <div>
        <h1>Prueba técnica</h1>
      </div>
      <div className="user-info">
        <h3>{usuario ? usuario.Nombre : "Usuario"}</h3>
        {usuario && (
          <button className="logout-button" onClick={manejarLogout}>
            Cerrar Sesión
          </button>
        )}
      </div>
    </header>
    <footer className="footer">
        <p>Desarrollado por Kevin Avila - desarrollador Junior | Contacto: kevintabuo@gmail.com</p>
      </footer>
    </div>
    
  );
};

export default Header;
