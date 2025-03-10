using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;

namespace PruebaTecnica.Models
{
    public class Usuario
    {
        private static string cadenaConexion = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;

        // Método para obtener todos los usuarios
        public static List<UsuarioModel> ObtenerUsuarios()
        {
            List<UsuarioModel> usuarios = new List<UsuarioModel>();

            using (SqlConnection conexion = new SqlConnection(cadenaConexion))
            {
                string query = "SELECT Id, Nombre, Apellidos, Cedula, CorreoElectronico, FechaUltimoAcceso, Puntaje FROM Usuarios";
                SqlCommand cmd = new SqlCommand(query, conexion);
                conexion.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    UsuarioModel usuario = new UsuarioModel
                    {
                        Id = Convert.ToInt32(reader["Id"]),
                        Nombre = reader["Nombre"].ToString(),
                        Apellidos = reader["Apellidos"].ToString(),
                        Cedula = reader["Cedula"].ToString(),
                        CorreoElectronico = reader["CorreoElectronico"].ToString(),
                        FechaUltimoAcceso = reader["FechaUltimoAcceso"] != DBNull.Value ? (DateTime?)Convert.ToDateTime(reader["FechaUltimoAcceso"]) : null,
                        Puntaje = Convert.ToInt32(reader["Puntaje"])
                    };
                    usuarios.Add(usuario);
                }
            }

            return usuarios;
        }

        public static bool InsertarUsuario(UsuarioModel usuario)
        {
            using (SqlConnection conexion = new SqlConnection(ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString))
            {
                string query = "EXEC InsertarUsuario @Nombre, @Apellidos, @Cedula, @CorreoElectronico, @Contraseña";
                SqlCommand cmd = new SqlCommand(query, conexion);
                cmd.Parameters.AddWithValue("@Nombre", usuario.Nombre);
                cmd.Parameters.AddWithValue("@Apellidos", usuario.Apellidos);
                cmd.Parameters.AddWithValue("@Cedula", usuario.Cedula);
                cmd.Parameters.AddWithValue("@CorreoElectronico", usuario.CorreoElectronico);
                cmd.Parameters.AddWithValue("@Contraseña", usuario.Contraseña);

                conexion.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public static bool ActualizarUsuario(UsuarioModel usuario)
        {
            using (SqlConnection conexion = new SqlConnection(ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString))
            {
                string query = "EXEC ActualizarUsuario @Id, @Nombre, @Apellidos, @Cedula, @CorreoElectronico, @Contraseña";
                SqlCommand cmd = new SqlCommand(query, conexion);
                cmd.Parameters.AddWithValue("@Id", usuario.Id);
                cmd.Parameters.AddWithValue("@Nombre", usuario.Nombre);
                cmd.Parameters.AddWithValue("@Apellidos", usuario.Apellidos);
                cmd.Parameters.AddWithValue("@Cedula", usuario.Cedula);
                cmd.Parameters.AddWithValue("@CorreoElectronico", usuario.CorreoElectronico);
                cmd.Parameters.AddWithValue("@Contraseña", usuario.Contraseña);

                conexion.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }

        public static bool EliminarUsuario(int id)
        {
            using (SqlConnection conexion = new SqlConnection(cadenaConexion))
            {
                string query = "DELETE FROM Usuarios WHERE Id=@Id";
                SqlCommand cmd = new SqlCommand(query, conexion);
                cmd.Parameters.AddWithValue("@Id", id);

                conexion.Open();
                int filasAfectadas = cmd.ExecuteNonQuery();
                return filasAfectadas > 0;
            }
        }

        public static UsuarioModel ValidarUsuario(string correo, string contraseña)
        {
            using (SqlConnection conexion = new SqlConnection(cadenaConexion))
            {
                string query = "EXEC ValidarUsuario @CorreoElectronico, @Contraseña";
                SqlCommand cmd = new SqlCommand(query, conexion);
                cmd.Parameters.AddWithValue("@CorreoElectronico", correo);
                cmd.Parameters.AddWithValue("@Contraseña", contraseña);

                conexion.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    string resultado = reader["Resultado"].ToString();

                    if (resultado == "OK")
                    {
                        return new UsuarioModel
                        {
                            Id = Convert.ToInt32(reader["Id"]),
                            Nombre = reader["Nombre"].ToString(),
                            Apellidos = reader["Apellidos"].ToString(),
                            Cedula = reader["Cedula"].ToString(),
                            CorreoElectronico = reader["CorreoElectronico"].ToString(),
                            FechaUltimoAcceso = reader["FechaUltimoAcceso"] != DBNull.Value ? (DateTime?)Convert.ToDateTime(reader["FechaUltimoAcceso"]) : null,
                            Puntaje = Convert.ToInt32(reader["Puntaje"])
                        };
                    }
                    else
                    {
                        return null;
                    }
                }
            }

            return null; 
        }



    }
}