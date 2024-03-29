USE [master]
GO
/****** Object:  Database [Drones]    Script Date: 29/02/2024 13:08:40 ******/
CREATE DATABASE [Drones]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Drones', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Drones.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Drones_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Drones_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Drones] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Drones].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Drones] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Drones] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Drones] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Drones] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Drones] SET ARITHABORT OFF 
GO
ALTER DATABASE [Drones] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Drones] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Drones] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Drones] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Drones] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Drones] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Drones] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Drones] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Drones] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Drones] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Drones] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Drones] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Drones] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Drones] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Drones] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Drones] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Drones] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Drones] SET RECOVERY FULL 
GO
ALTER DATABASE [Drones] SET  MULTI_USER 
GO
ALTER DATABASE [Drones] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Drones] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Drones] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Drones] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Drones] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Drones] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Drones', N'ON'
GO
ALTER DATABASE [Drones] SET QUERY_STORE = OFF
GO
USE [Drones]
GO
/****** Object:  User [Gene]    Script Date: 29/02/2024 13:08:41 ******/
CREATE USER [Gene] FOR LOGIN [Gene] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Table [dbo].[Carrito]    Script Date: 29/02/2024 13:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Carrito](
	[ID_Compra] [int] IDENTITY(1,1) NOT NULL,
	[Identificacion] [int] NOT NULL,
	[Numero_Serie] [varchar](50) NOT NULL,
	[Modelo] [varchar](50) NOT NULL,
	[Cantidad] [int] NOT NULL,
	[Precio] [int] NOT NULL,
	[Precio_Total] [int] NOT NULL,
 CONSTRAINT [PK_Carrito] PRIMARY KEY CLUSTERED 
(
	[ID_Compra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Historial]    Script Date: 29/02/2024 13:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Historial](
	[Identificacion] [int] NOT NULL,
	[ID_Factura] [int] NOT NULL,
	[ID_Compra] [int] NOT NULL,
	[Monto] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Login]    Script Date: 29/02/2024 13:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Login](
	[Identificacion] [int] NOT NULL,
	[Contraseña] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Pago]    Script Date: 29/02/2024 13:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pago](
	[ID_Factura] [int] IDENTITY(1,1) NOT NULL,
	[ID_Compra] [int] NOT NULL,
	[Tipo_Pago] [varchar](500) NOT NULL,
 CONSTRAINT [PK_Pago] PRIMARY KEY CLUSTERED 
(
	[ID_Factura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Producto]    Script Date: 29/02/2024 13:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Producto](
	[Numero_Serie] [varchar](50) NOT NULL,
	[Tipo] [varchar](50) NOT NULL,
	[Modelo] [varchar](50) NOT NULL,
	[Descripcion] [varchar](200) NOT NULL,
	[Ficha_tecnica] [varchar](200) NOT NULL,
	[Precio] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Registro]    Script Date: 29/02/2024 13:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Registro](
	[Identificacion] [int] NOT NULL,
	[Nombre] [varchar](500) NOT NULL,
	[Telefono] [int] NOT NULL,
	[Correo] [varchar](50) NOT NULL,
	[Contraseña] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Registro] PRIMARY KEY CLUSTERED 
(
	[Identificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Carrito]  WITH CHECK ADD  CONSTRAINT [FK_Carrito_Registro] FOREIGN KEY([Identificacion])
REFERENCES [dbo].[Registro] ([Identificacion])
GO
ALTER TABLE [dbo].[Carrito] CHECK CONSTRAINT [FK_Carrito_Registro]
GO
/****** Object:  StoredProcedure [dbo].[ActualizarCantidadCarrito]    Script Date: 29/02/2024 13:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ActualizarCantidadCarrito]
    @Numero_Serie VARCHAR(50),
    @NuevaCantidad INT,
    @Identificacion INT,
    @NuevoPrecioTotal DECIMAL(18, 2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Obtener el Precio actual de la tabla Carrito
    DECLARE @PrecioActual DECIMAL(18, 2);
    SELECT @PrecioActual = Precio
    FROM Carrito
    WHERE Identificacion = @Identificacion AND Numero_Serie = @Numero_Serie;

    -- Actualizar la cantidad en la tabla Carrito
    UPDATE Carrito
    SET Cantidad = @NuevaCantidad,
        Precio_Total = @NuevaCantidad * @PrecioActual -- Calcular el nuevo Precio_Total basado en el Precio actual
    WHERE Identificacion = @Identificacion AND Numero_Serie = @Numero_Serie;

    -- Devolver el nuevo Precio_Total
    SELECT @NuevoPrecioTotal = Precio_Total
    FROM Carrito
    WHERE Identificacion = @Identificacion AND Numero_Serie = @Numero_Serie;
END
GO
/****** Object:  StoredProcedure [dbo].[AgregarAlCarrito]    Script Date: 29/02/2024 13:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AgregarAlCarrito]
    @Identificacion INT,
    @Numero_Serie VARCHAR(50),
    @Modelo VARCHAR(50),
    @Cantidad INT,
    @Precio INT,
    @Precio_Total INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el producto ya está en el carrito para este usuario
    IF NOT EXISTS (SELECT 1 FROM dbo.Carrito WHERE Identificacion = @Identificacion AND Modelo = @Modelo)
    BEGIN
        -- Si no existe, agregar un nuevo artículo al carrito
        INSERT INTO dbo.Carrito (Identificacion, Numero_Serie, Modelo, Cantidad, Precio, Precio_Total)
        VALUES (@Identificacion, @Numero_Serie, @Modelo, @Cantidad, @Precio, @Precio_Total);
    END
    ELSE
    BEGIN
        -- Si el producto ya está en el carrito, puedes optar por actualizar la cantidad o hacer otra lógica según tus necesidades.
        UPDATE dbo.Carrito
        SET Cantidad = Cantidad + @Cantidad,
            Precio_Total = Precio_Total + @Precio_Total
        WHERE Identificacion = @Identificacion AND Modelo = @Modelo;
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[BorrarCarritoPorIdentificacion]    Script Date: 29/02/2024 13:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BorrarCarritoPorIdentificacion]
    @Identificacion INT
AS
BEGIN
    DELETE FROM Carrito WHERE Identificacion = @Identificacion;
END
GO
/****** Object:  StoredProcedure [dbo].[BuscarHistorialPorIdentificacion]    Script Date: 29/02/2024 13:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BuscarHistorialPorIdentificacion] (@identificacion INT)
AS
BEGIN
    SELECT ID_Factura, ID_Compra, Monto
    FROM Historial
    WHERE Identificacion = @identificacion;
END;
GO
/****** Object:  StoredProcedure [dbo].[InsertRegistro]    Script Date: 29/02/2024 13:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertRegistro]
    @Identificacion INT,
    @Nombre VARCHAR(500),
    @Telefono INT,
    @Correo VARCHAR(50),
    @Contraseña VARCHAR(50)
AS
BEGIN
    BEGIN TRANSACTION;

    -- Verificar si los datos ya existen en la tabla Registro
    IF NOT EXISTS (SELECT 1 FROM Registro WHERE Identificacion = @Identificacion)
    BEGIN
        -- Si no existen, realizar la inserción
        INSERT INTO Registro (Identificacion, Nombre, Telefono, Correo, Contraseña)
        VALUES (@Identificacion, @Nombre, @Telefono, @Correo, @Contraseña);

        -- Puedes agregar más lógica aquí si es necesario
        PRINT 'Registro insertado correctamente.';

        COMMIT;
    END
    ELSE
    BEGIN
        -- Si la identificación ya existe, hacer rollback y lanzar un mensaje de error
        ROLLBACK;
        THROW 50000, 'Los datos ya existen en la tabla Registro.', 1;
    END
END





GO
/****** Object:  StoredProcedure [dbo].[ObtenerCarritoPorIdentificacion]    Script Date: 29/02/2024 13:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE PROCEDURE [dbo].[ObtenerCarritoPorIdentificacion]
    @Identificacion INT
AS
BEGIN
    SELECT Numero_Serie, Modelo, Cantidad, Precio, Precio_Total
    FROM Carrito
    WHERE Identificacion = @Identificacion;
END;
GO
/****** Object:  StoredProcedure [dbo].[ObtenerProductosDrones]    Script Date: 29/02/2024 13:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Genesis Barahona Quirós>
-- Create date: <21/02/2024>
-- Description:	<Drones>
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerProductosDrones]
AS
BEGIN
    SELECT Tipo, Modelo, Descripcion, Ficha_tecnica, Precio
    FROM Producto
    WHERE tipo = 'drone';
END;
GO
/****** Object:  StoredProcedure [dbo].[ObtenerProductosTraktor]    Script Date: 29/02/2024 13:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Génesis Barahona Quirós>
-- Create date: <21/02/2024>
-- Description:	<Traktor>
-- =============================================
CREATE PROCEDURE [dbo].[ObtenerProductosTraktor]
AS
BEGIN
    SELECT tipo, modelo, descripcion, ficha_tecnica, precio
    FROM Producto
    WHERE tipo = 'tractor';
END;
GO
/****** Object:  StoredProcedure [dbo].[ObtenerTotalAPagar]    Script Date: 29/02/2024 13:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerTotalAPagar]
    @Identificacion INT
AS
BEGIN
    SELECT Identificacion, ISNULL(SUM(Precio_Total), 0) AS TotalAPagar
    FROM Carrito
    WHERE Identificacion = @Identificacion
    GROUP BY Identificacion;
END
GO
/****** Object:  StoredProcedure [dbo].[ValidarCredenciales]    Script Date: 29/02/2024 13:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Génesis Barahona Quirós>
-- Create date: <19/02/2024>
-- Description:	<Validar login>
-- =============================================
CREATE PROCEDURE [dbo].[ValidarCredenciales]
    @Identificacion INT,
    @Contraseña VARCHAR(50),
    @Resultado INT OUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Inicializar el resultado
    SET @Resultado = 0;

    -- Verificar si las credenciales son válidas (insensible a mayúsculas y minúsculas)
    IF EXISTS (SELECT 1 FROM Login WHERE Identificacion = @Identificacion AND LOWER(Contraseña) = LOWER(@Contraseña))
    BEGIN
        -- Si las credenciales son válidas, establecer el resultado en 1
        SET @Resultado = 1;
    END
END

GO
/****** Object:  Trigger [dbo].[trg_InsertarLogin]    Script Date: 29/02/2024 13:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Génesis Barahona Quirós>
-- Create date: <18/02/2001>
-- Description:	<Insertar identificacion y contraseña>
-- =============================================
CREATE TRIGGER [dbo].[trg_InsertarLogin]
ON [dbo].[Registro]
AFTER INSERT
AS
BEGIN
    -- Insertar en la tabla de login
    INSERT INTO Login (Identificacion, Contraseña)
    SELECT Identificacion, Contraseña
    FROM inserted;
END;
GO
ALTER TABLE [dbo].[Registro] ENABLE TRIGGER [trg_InsertarLogin]
GO
USE [master]
GO
ALTER DATABASE [Drones] SET  READ_WRITE 
GO
