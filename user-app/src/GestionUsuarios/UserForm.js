import React, { useState, useEffect } from "react";
import { agregarUsuario, actualizarUsuario } from "../api";
import "./UserForm.css";

const UserForm = ({ usuarioEditando, setUsuarioEditando, cargarUsuarios, onClose }) => {
    const [usuario, setUsuario] = useState({
        id: 0,
        nombre: "",
        apellidos: "",
        cedula: "",
        correoElectronico: "",
        contraseña: "",
        puntaje: 0,
        fechaUltimoAcceso: null
    });

    const [esNuevoUsuario, setEsNuevoUsuario] = useState(true);

    // Cargar datos al editar un usuario
    useEffect(() => {
        if (usuarioEditando) {
            setUsuario({
                id: usuarioEditando.Id || 0,
                nombre: usuarioEditando.Nombre || "",
                apellidos: usuarioEditando.Apellidos || "",
                cedula: usuarioEditando.Cedula || "",
                correoElectronico: usuarioEditando.CorreoElectronico || "",
                contraseña: "", // No cargamos la contraseña por seguridad
                puntaje: usuarioEditando.Puntaje || 0,
                fechaUltimoAcceso: usuarioEditando.FechaUltimoAcceso || null
            });
            setEsNuevoUsuario(false);
        } else {
            setUsuario({
                id: 0,
                nombre: "",
                apellidos: "",
                cedula: "",
                correoElectronico: "",
                contraseña: "",
                puntaje: 0,
                fechaUltimoAcceso: null
            });
            setEsNuevoUsuario(true);
        }
    }, [usuarioEditando]);

    // Manejo de cambios en los inputs
    const handleChange = (e) => {
        setUsuario({ ...usuario, [e.target.name]: e.target.value });
    };

    // Envío del formulario
    const handleSubmit = async (e) => {
        e.preventDefault();

        // Validar campos obligatorios
        if (!usuario.nombre || !usuario.apellidos || !usuario.cedula || !usuario.correoElectronico) {
            alert("Todos los campos son obligatorios");
            return;
        }

        if (esNuevoUsuario && usuario.contraseña.length < 6) {
            alert("La contraseña debe tener al menos 6 caracteres");
            return;
        }

        try {
            if (!esNuevoUsuario) {
                await actualizarUsuario(usuario.id, usuario);
                alert("Usuario actualizado correctamente");
            } else {
                await agregarUsuario(usuario);
                alert("Usuario agregado correctamente");
            }

            cargarUsuarios(); // Recargar la lista de usuarios
            setUsuarioEditando(null); // Resetear edición
            onClose(); // Cerrar modal
        } catch (error) {
            console.error("Error al guardar usuario:", error);
            alert("Hubo un error al guardar el usuario");
        }
    };

    return (
        <div className="form-container">
            <h2>{esNuevoUsuario ? "Agregar usuario" : "Editar usuario"}</h2>
            <form onSubmit={handleSubmit}>
                <input type="text" name="nombre" placeholder="Nombre" value={usuario.nombre} onChange={handleChange} required />
                <input type="text" name="apellidos" placeholder="Apellidos" value={usuario.apellidos} onChange={handleChange} required />
                <input type="text" name="cedula" placeholder="Cédula" value={usuario.cedula} onChange={handleChange} required />
                <input type="email" name="correoElectronico" placeholder="Correo Electrónico" value={usuario.correoElectronico} onChange={handleChange} required />
                
                {esNuevoUsuario && (
                    <input type="password" name="contraseña" placeholder="Contraseña" value={usuario.contraseña} onChange={handleChange} required />
                )}

                <div className="btnsForm">
                    <button type="button" onClick={onClose}>Cancelar</button>
                    <button type="submit">{esNuevoUsuario ? "Agregar" : "Actualizar"}</button>
                </div>
            </form>
        </div>
    );
};

export default UserForm;
