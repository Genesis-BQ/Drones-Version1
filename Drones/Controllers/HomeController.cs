using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Mvc;
using Drones.Models;


namespace Drones.Controllers
{
    public class HomeController : Controller
    {
        private string connectionString = LibroV.connectionString;

        // GET: Home
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Home()
        {
            return View();
        }

        public ActionResult Registrar()
        {
            
            return View();
        }

        public ActionResult CargarDatos()
        {
            try
            {
                int identificacion;
                if (!int.TryParse(Request.Form["identificacion"]?.ToString(), out identificacion))
                {
                    return View("ErrorRegistro");
                }

                string nombre = Request.Form["nombre"]?.ToString();

                int telefono;
                if (!int.TryParse(Request.Form["telefono"]?.ToString(), out telefono))
                {
                    return View("ErrorRegistro");
                }

                string correo = Request.Form["correo"]?.ToString();
                string contraseña = Request.Form["contraseña"]?.ToString();

                // Verificar la existencia del registro antes de realizar el registro
                LibroV libro = new LibroV();

                // Llamada al procedimiento almacenado para realizar el registro
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    using (SqlCommand cmd = new SqlCommand("InsertRegistro", connection))
                    {
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        // Parámetros del procedimiento almacenado
                        cmd.Parameters.AddWithValue("@Identificacion", identificacion);
                        cmd.Parameters.AddWithValue("@Nombre", nombre);
                        cmd.Parameters.AddWithValue("@Telefono", telefono);
                        cmd.Parameters.AddWithValue("@Correo", correo);
                        cmd.Parameters.AddWithValue("@Contraseña", contraseña);

                        cmd.ExecuteNonQuery();
                    }
                }

                return View("CargarDatos");
            }
            catch (SqlException ex)
            {
                if (ex.Number == 2627)
                {
                    return View("ErrorRegistro");
                }
                else
                {
                    return View("ErrorRegistro");
                }
            }
            catch (Exception ex)
            {
               
                return View("ErrorRegistro");
            }
        }

        public ActionResult Validarlogin()
        {
            string identificacionS = Request.Form["identificacion"]?.ToString();

            if (string.IsNullOrEmpty(identificacionS))
            {
               
                return View("ErrorInicioSesion");
            }

            if (int.TryParse(identificacionS, out int identificacion))
            {
                string contrasena = Request.Form["contrasena"]?.ToString();

                if (string.IsNullOrEmpty(contrasena))
                {
                    
                    return View("ErrorInicioSesion");
                }

                LibroV libro = new LibroV();

                if (libro.ValidarCredenciales(identificacion, contrasena))
                {
                    
                    Session["UsuarioIdentificacion"] = identificacion;


                    return View("Validarlogin");
                }
            }

           
            return View("ErrorInicioSesion");
        }

        public ActionResult ErrorInicioSesion()
        {

            return View();
        }

        public ActionResult ErrorRegistro()
        {

            return View();
        }

        public ActionResult Drones()
        {
            List<Drone> drones = GetDronesFromDatabase();
            return View(drones);
        }

        private List<Drone> GetDronesFromDatabase()
        {
            List<Drone> drones = new List<Drone>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlCommand command = new SqlCommand("ObtenerProductosDrones", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Drone drone = new Drone
                            {
                                Tipo = Convert.ToString(reader["Tipo"]),
                                Modelo = Convert.ToString(reader["Modelo"]),
                                Descripcion = Convert.ToString(reader["Descripcion"]),
                                FichaTecnica = Convert.ToString(reader["Ficha_tecnica"]),
                                Precio = Convert.ToDecimal(reader["Precio"])
                            };

                            drones.Add(drone);
                        }
                    }
                }
            }

            return drones;
        }

        public ActionResult AgregarAlCarrito()
        {
            return View();
        }


        [HttpPost]
        public ActionResult AgregarAlCarrito(FormCollection form)
        {
           
            string modelo = form["modelo"];
            int precio = Convert.ToInt32(form["precio"]);

            
            int identificacionUsuario = Convert.ToInt32(Session["UsuarioIdentificacion"]);

           
            string numeroSerie = ObtenerNumeroSerieDesdeBD(modelo);

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("dbo.AgregarAlCarrito", connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parámetros del procedimiento almacenado
                    cmd.Parameters.AddWithValue("@Identificacion", identificacionUsuario);
                    cmd.Parameters.AddWithValue("@Numero_Serie", numeroSerie); // Tomar de la base de datos
                    cmd.Parameters.AddWithValue("@Modelo", modelo);
                    cmd.Parameters.AddWithValue("@Cantidad", 1); // Asumiendo que siempre se agrega una unidad
                    cmd.Parameters.AddWithValue("@Precio", precio);
                    cmd.Parameters.AddWithValue("@Precio_Total", precio);

                    // Ejecutar el procedimiento almacenado
                    cmd.ExecuteNonQuery();
                }
            }

            
            return RedirectToAction("Home");
        }

        public ActionResult Pagar()
        {
            return View();
        }

        public ActionResult Paypal()
        {
            int identificacionUsuario = ObtenerIdentificacionUsuario();
            decimal totalAPagar = ObtenerTotalAPagar(identificacionUsuario);

            ViewBag.TotalAPagar = totalAPagar;
            ViewBag.IdentificacionUsuario = identificacionUsuario;

            return View();
        }

        public ActionResult Tarjeta()
        {
            int identificacionUsuario = ObtenerIdentificacionUsuario();
            decimal totalAPagar = ObtenerTotalAPagar(identificacionUsuario);

            ViewBag.TotalAPagar = totalAPagar;
            ViewBag.IdentificacionUsuario = identificacionUsuario;

            return View();
        }

        public ActionResult Tranferencia()
        {
            int identificacionUsuario = ObtenerIdentificacionUsuario();
            decimal totalAPagar = ObtenerTotalAPagar(identificacionUsuario);

            ViewBag.TotalAPagar = totalAPagar;
            ViewBag.IdentificacionUsuario = identificacionUsuario;

            return View();
        }

        // Método para obtener el número de serie desde la base de datos
        private string ObtenerNumeroSerieDesdeBD(string modelo)
        {
            string numeroSerie = string.Empty;

            // Ajusta la consulta según la estructura de tu tabla de productos
            string query = "SELECT Numero_Serie FROM Producto WHERE Modelo = @Modelo";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand(query, connection))
                {
                    cmd.Parameters.AddWithValue("@Modelo", modelo);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            numeroSerie = reader["Numero_Serie"].ToString();
                        }
                    }
                }
            }

            return numeroSerie;
        }


        public ActionResult Traktor()
        {
            List<Traktor> traktors = GetTraktorFromDatabase();
            return View(traktors);
        }
        private List<Traktor> GetTraktorFromDatabase()
        {
            List<Traktor> traktorsList = new List<Traktor>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlCommand command = new SqlCommand("ObtenerProductosTraktor", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Traktor traktor = new Traktor
                            {
                                Tipo = Convert.ToString(reader["Tipo"]),
                                Modelo = Convert.ToString(reader["Modelo"]),
                                Descripcion = Convert.ToString(reader["Descripcion"]),
                                FichaTecnica = Convert.ToString(reader["Ficha_tecnica"]),
                                Precio = Convert.ToDecimal(reader["Precio"])
                            };

                            traktorsList.Add(traktor); 
                        }
                    }
                }
            }

            return traktorsList; 
        }
       
        private int ObtenerIdentificacionUsuario()
        {
            
            if (Session["UsuarioIdentificacion"] != null)
            {
                
                return Convert.ToInt32(Session["UsuarioIdentificacion"]);
            }
            else
            {
             
                return -1;
            }
        }

        private List<Carrito> ObtenerCarritoDesdeBaseDatos()
        {
            int identificacionUsuario = ObtenerIdentificacionUsuario();
            if (identificacionUsuario == -1)
            {
                
                return new List<Carrito>();
            }

            List<Carrito> carritoItems = new List<Carrito>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

               
                string query = "SELECT * FROM Carrito WHERE Identificacion = @Identificacion";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Identificacion", identificacionUsuario);
                    SqlDataReader reader = command.ExecuteReader();

                    while (reader.Read())
                    {
                        Carrito item = new Carrito
                        {
                            Numero_Serie = reader["Numero_Serie"].ToString(),
                            Modelo = reader["Modelo"].ToString(),
                            Cantidad = Convert.ToInt32(reader["Cantidad"]), 
                            Precio = Convert.ToDecimal(reader["Precio"]), 
                            Precio_Total = Convert.ToDecimal(reader["Precio_Total"]) 
                        };


                        carritoItems.Add(item);
                    }
                }
            }

            return carritoItems;
        }

        
        public ActionResult Carrito()
        {
            List<Carrito> carritoItems = ObtenerCarritoDesdeBaseDatos();
            return View(carritoItems);
        }

        
        [HttpPost]
        public ActionResult ActualizarCantidad(string numeroSerie, int nuevaCantidad, decimal? nuevoPrecio)
        {
            int identificacionUsuario = ObtenerIdentificacionUsuario();
            if (identificacionUsuario == -1)
            {
               
                return RedirectToAction("Login"); 
            }

            decimal nuevoPrecioTotal = 0; 

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlCommand command = new SqlCommand("ActualizarCantidadCarrito", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Numero_Serie", numeroSerie);
                    command.Parameters.AddWithValue("@NuevaCantidad", nuevaCantidad);
                    command.Parameters.AddWithValue("@Identificacion", identificacionUsuario);

                    SqlParameter nuevoPrecioTotalParam = new SqlParameter("@NuevoPrecioTotal", SqlDbType.Decimal);
                    nuevoPrecioTotalParam.Precision = 18;
                    nuevoPrecioTotalParam.Scale = 2;
                    nuevoPrecioTotalParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(nuevoPrecioTotalParam);

                    command.ExecuteNonQuery();

                    
                    nuevoPrecioTotal = (decimal)nuevoPrecioTotalParam.Value;
                }
            }
            
            return RedirectToAction("Carrito");
        }

        public ActionResult MostrarTotalAPagar()
        {
            int identificacionUsuario = ObtenerIdentificacionUsuario();

            if (identificacionUsuario == -1)
            {
                
                return RedirectToAction("Login"); 
            }

            decimal totalAPagar = ObtenerTotalAPagar(identificacionUsuario);

            ViewBag.TotalAPagar = totalAPagar;

            return View();
        }

        private decimal ObtenerTotalAPagar(int identificacionUsuario)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                SqlCommand command = new SqlCommand("ObtenerTotalAPagar", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Identificacion", identificacionUsuario);

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    decimal totalAPagar = 0;

                    while (reader.Read())
                    {
                       
                        totalAPagar += Convert.ToDecimal(reader["TotalAPagar"]);
                    }

                    return totalAPagar;
                }
            }
        }

        public ActionResult PagarYBorrar()
        {
            int identificacionUsuario = ObtenerIdentificacionUsuario();

            if (identificacionUsuario == -1)
            {
               
                return RedirectToAction("Login"); 
            }

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                using (SqlCommand command = new SqlCommand("BorrarCarritoPorIdentificacion", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Identificacion", identificacionUsuario);

                    command.ExecuteNonQuery();
                }
            }

            

            return RedirectToAction("Home");
        }

    }
}