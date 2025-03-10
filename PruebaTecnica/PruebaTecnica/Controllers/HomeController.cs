using PruebaTecnica.Models;
using System;
using System.Collections.Generic;
using System.Net;
using System.Web.Http;


[RoutePrefix("api/usuarios")]
public class HomeController : ApiController
{
    [HttpGet]
    [Route("consulta")]
    public IHttpActionResult ObtenerUsuarios()
    {
        try
        {
            List<UsuarioModel> usuarios = Usuario.ObtenerUsuarios();
            return Ok(new { success = true, data = usuarios });
        }
        catch (Exception ex)
        {
            return InternalServerError(new Exception("Ocurrió un error al obtener los usuarios. " + ex.Message));
        }
    }


    [HttpPost]
    [Route("agregar")]
    public IHttpActionResult AgregarUsuario(UsuarioModel usuario)
    {
        if (usuario == null)
            return Content(HttpStatusCode.BadRequest, new { success = false, message = "Los datos enviados son inválidos." });

        try
        {
            bool resultado = Usuario.InsertarUsuario(usuario);
            if (resultado)
                return Ok(new { success = true, message = "Usuario agregado correctamente." });

            return Content(HttpStatusCode.BadRequest, new { success = false, message = "No se pudo agregar el usuario. Verifique los datos." });
        }
        catch (Exception ex)
        {
            return InternalServerError(new Exception($"Error al agregar usuario. {ex.Message}"));
        }
    }

    [HttpPut]
    [Route("actualizar/{id:int}")]
    public IHttpActionResult ActualizarUsuario(int id, UsuarioModel usuario)
    {
        if (usuario == null || id != usuario.Id)
            return Content(HttpStatusCode.BadRequest, new { success = false, message = "Datos inválidos. Verifique el ID del usuario." });

        try
        {
            bool resultado = Usuario.ActualizarUsuario(usuario);
            if (resultado)
                return Ok(new { success = true, message = "Usuario actualizado correctamente." });

            return Content(HttpStatusCode.NotFound, new { success = false, message = "No se encontró el usuario para actualizar." });
        }
        catch (Exception ex)
        {
            return InternalServerError(new Exception($"Error al actualizar usuario. {ex.Message}"));
        }
    }

    [HttpDelete]
    [Route("eliminar/{id:int}")]
    public IHttpActionResult EliminarUsuario(int id)
    {
        try
        {
            bool resultado = Usuario.EliminarUsuario(id);
            if (resultado)
                return Ok(new { success = true, message = "Usuario eliminado correctamente." });

            return Content(HttpStatusCode.NotFound, new { success = false, message = "No se encontró el usuario para eliminar." });
        }
        catch (Exception ex)
        {
            return InternalServerError(new Exception($"Error al eliminar usuario. {ex.Message}"));
        }
    }

    [HttpPost]
    [Route("login")]
    public IHttpActionResult Login(UsuarioModel usuario)
    {
        if (usuario == null || string.IsNullOrEmpty(usuario.CorreoElectronico) || string.IsNullOrEmpty(usuario.Contraseña))
            return Content(HttpStatusCode.BadRequest, new { success = false, message = "Correo y contraseña son requeridos." });

        try
        {
            UsuarioModel usuarioAutenticado = Usuario.ValidarUsuario(usuario.CorreoElectronico, usuario.Contraseña);

            if (usuarioAutenticado != null)
            {
                return Ok(new { success = true, message = "Login exitoso.", data = usuarioAutenticado });
            }

            return Content(HttpStatusCode.Unauthorized, new { success = false, message = "Credenciales incorrectas." });
        }
        catch (Exception ex)
        {
            return InternalServerError(new Exception($"Error en el login. {ex.Message}"));
        }
    }
}
