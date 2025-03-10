using System;

namespace PruebaTecnica.Models
{
    public class UsuarioModel
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Apellidos { get; set; }
        public string Cedula { get; set; }
        public string CorreoElectronico { get; set; }
        public string Contraseña { get; set; }
        public int Puntaje { get; set; }
        public DateTime? FechaUltimoAcceso { get; set; }
    }

}