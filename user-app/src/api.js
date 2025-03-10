import axios from "axios";

const API_URL = "https://localhost:44346/api/usuarios";

// Manejo global de errores
const manejarErrores = (error) => {
  if (error.response) {
    console.error("Error en API:", error.response.data);
    return { success: false, message: error.response.data.message || "Error en la solicitud" };
  } else {
    console.error("Error desconocido:", error.message);
    return { success: false, message: "Error desconocido en la API" };
  }
};

// Obtener usuarios
export const obtenerUsuarios = async () => {
  try {
    const response = await axios.get(`${API_URL}/consulta`);
    console.log(response);
    return response.data.data;
  } catch (error) {
    return manejarErrores(error);
  }
};

// Agregar usuario
export const agregarUsuario = async (usuario) => {
  try {
    const response = await axios.post(`${API_URL}/agregar`, usuario);
    alert(response.data.message);
    return response.data;
  } catch (error) {
    return manejarErrores(error);
  }
};

// Actualizar usuario
export const actualizarUsuario = async (id, usuario) => {
  try {
    const response = await axios.put(`${API_URL}/actualizar/${id}`, usuario);
    alert(response.data.message);
    return response.data;
  } catch (error) {
    return manejarErrores(error);
  }
};

// Eliminar usuario
export const eliminarUsuario = async (id) => {
  try {
    const response = await axios.delete(`${API_URL}/eliminar/${id}`);
    alert(response.data.message);
    return response.data;
  } catch (error) {
    return manejarErrores(error);
  }
};

// Login de usuario
export const loginUsuario = async (credenciales) => {
  try {
    const response = await axios.post(`${API_URL}/login`, credenciales);
    return response.data; 
  } catch (error) {
    return manejarErrores(error); 
  }
};

