import React, { useEffect, useState } from "react";
import './UserList.css';
import { obtenerUsuarios, eliminarUsuario } from "../api";
import UserForm from "./UserForm";
import Modal from "./Modal";
import { useNavigate } from "react-router-dom";

const UsuariosList = () => {
    const [usuarios, setUsuarios] = useState([]);
    const [usuarioEditando, setUsuarioEditando] = useState(null);
    const [modalAbierto, setModalAbierto] = useState(false);
    const navigate = useNavigate();

    useEffect(() => {
        const usuario = localStorage.getItem("usuario");
        if (!usuario) {
            navigate("/"); // Redirigir al login si no hay usuario
            return;
        }
        cargarUsuarios();
    }, [navigate]);

    const cargarUsuarios = async () => {
        const data = await obtenerUsuarios();
        setUsuarios(data);
    };

    const handleEliminar = async (id) => {
        if (window.confirm("¿Estás seguro de eliminar este usuario?")) {
            await eliminarUsuario(id);
            cargarUsuarios();
        }
    };

    const abrirModal = (usuario = null) => {
        setUsuarioEditando(usuario);
        setModalAbierto(true);
    };

    const clasificarUsuario = (fechaUltimoAcceso) => {
        if (!fechaUltimoAcceso) return "Olvidado"; // Si no tiene fecha, se considera "Olvidado"

        const ahora = new Date();
        const fechaAcceso = new Date(fechaUltimoAcceso);
        const diferenciaHoras = (ahora - fechaAcceso) / (1000 * 60 * 60); // Convierte la diferencia a horas

        if (diferenciaHoras <= 12) {
            return "Hechicero";
        } else if (diferenciaHoras > 12 && diferenciaHoras <= 48) {
            return "Luchador";
        } else if (diferenciaHoras > 48 && diferenciaHoras <= 168) { // 168 horas = 7 días
            return "Explorador";
        } else {
            return "Olvidado";
        }
    };

    return (
        <div className="container">
            <h2>Lista de usuarios</h2>
            <div className="btnAgregarDisplay">
                <button className="btnAgregar" onClick={() => abrirModal()}>Agregar</button>
            </div>

            <Modal isOpen={modalAbierto} onClose={() => setModalAbierto(false)}>
                <UserForm usuarioEditando={usuarioEditando} setUsuarioEditando={setUsuarioEditando} cargarUsuarios={cargarUsuarios} onClose={() => setModalAbierto(false)} />
            </Modal>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Apellidos</th>
                        <th>Cédula</th>
                        <th>Correo</th>
                        <th>Ultimo acceso</th>
                        <th>Puntaje</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    {usuarios.map((usuario) => (
                        <tr key={usuario.Id}>
                            <td>{usuario.Id}</td>
                            <td>{usuario.Nombre}</td>
                            <td>{usuario.Apellidos}</td>
                            <td>{usuario.Cedula}</td>
                            <td>{usuario.CorreoElectronico}</td>
                            <td>{clasificarUsuario(usuario.FechaUltimoAcceso)}</td>
                            <td>{usuario.Puntaje}</td>
                            <td className="buttons">
                                <button className="btnEditar" onClick={() => abrirModal(usuario)}>
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                        <path d="M12 20h9"></path>
                                        <path d="M16.5 3.5a2.121 2.121 0 013 3L7 19l-4 1 1-4L16.5 3.5z"></path>
                                    </svg>
                                </button>
                                <button className="btnEliminar" onClick={() => handleEliminar(usuario.Id)}>
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                                        <polyline points="3 6 5 6 21 6"></polyline>
                                        <path d="M19 6l-2 14H7L5 6"></path>
                                        <path d="M10 11l0 6"></path>
                                        <path d="M14 11l0 6"></path>
                                        <path d="M4 6L5 6 6 6"></path>
                                        <path d="M9 6L10 6 15 6"></path>
                                    </svg>
                                </button>
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
};

export default UsuariosList;
