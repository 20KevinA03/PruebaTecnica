USE [master]
GO
/****** Object:  Database [PruebaTecnica]    Script Date: 28/02/2025 16:12:23 ******/
CREATE DATABASE [PruebaTecnica]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PruebaTecnica', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\PruebaTecnica.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PruebaTecnica_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\PruebaTecnica_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [PruebaTecnica] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PruebaTecnica].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PruebaTecnica] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PruebaTecnica] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PruebaTecnica] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PruebaTecnica] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PruebaTecnica] SET ARITHABORT OFF 
GO
ALTER DATABASE [PruebaTecnica] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PruebaTecnica] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PruebaTecnica] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PruebaTecnica] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PruebaTecnica] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PruebaTecnica] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PruebaTecnica] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PruebaTecnica] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PruebaTecnica] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PruebaTecnica] SET  DISABLE_BROKER 
GO
ALTER DATABASE [PruebaTecnica] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PruebaTecnica] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PruebaTecnica] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PruebaTecnica] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PruebaTecnica] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PruebaTecnica] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PruebaTecnica] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PruebaTecnica] SET RECOVERY FULL 
GO
ALTER DATABASE [PruebaTecnica] SET  MULTI_USER 
GO
ALTER DATABASE [PruebaTecnica] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PruebaTecnica] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PruebaTecnica] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PruebaTecnica] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PruebaTecnica] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [PruebaTecnica] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'PruebaTecnica', N'ON'
GO
ALTER DATABASE [PruebaTecnica] SET QUERY_STORE = ON
GO
ALTER DATABASE [PruebaTecnica] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [PruebaTecnica]
GO
/****** Object:  User [kevinAv]    Script Date: 28/02/2025 16:12:23 ******/
CREATE USER [kevinAv] FOR LOGIN [kevinAv] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [kevinAv]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [kevinAv]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [kevinAv]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [kevinAv]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [kevinAv]
GO
ALTER ROLE [db_datareader] ADD MEMBER [kevinAv]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [kevinAv]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [kevinAv]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [kevinAv]
GO
/****** Object:  UserDefinedFunction [dbo].[CalcularPuntajeUsuario]    Script Date: 28/02/2025 16:12:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CalcularPuntajeUsuario] (
    @Nombre NVARCHAR(100), 
    @Apellidos NVARCHAR(150), 
    @Correo NVARCHAR(150)
)
RETURNS INT
AS
BEGIN
    DECLARE @Puntaje INT = 0;

    -- Evaluar la longitud del nombre completo
    IF LEN(@Nombre + ' ' + @Apellidos) > 10
        SET @Puntaje = @Puntaje + 20;
    ELSE IF LEN(@Nombre + ' ' + @Apellidos) BETWEEN 5 AND 10
        SET @Puntaje = @Puntaje + 10;

    -- Evaluar el dominio del correo
    IF @Correo LIKE '%@gmail.com'
        SET @Puntaje = @Puntaje + 40;
    ELSE IF @Correo LIKE '%@hotmail.com'
        SET @Puntaje = @Puntaje + 20;
    ELSE
        SET @Puntaje = @Puntaje + 10;

    RETURN @Puntaje;
END;
GO
/****** Object:  Table [dbo].[Usuarios]    Script Date: 28/02/2025 16:12:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NOT NULL,
	[Apellidos] [varchar](150) NOT NULL,
	[Cedula] [varchar](20) NOT NULL,
	[CorreoElectronico] [varchar](150) NOT NULL,
	[FechaUltimoAcceso] [datetime] NULL,
	[Contraseña] [varchar](255) NOT NULL,
	[Puntaje] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Usuarios] ON 

INSERT [dbo].[Usuarios] ([Id], [Nombre], [Apellidos], [Cedula], [CorreoElectronico], [FechaUltimoAcceso], [Contraseña], [Puntaje]) VALUES (1, N'Ana', N'Gómez', N'987654321', N'ana.gomez@gmail.com', NULL, N'secreta123', 50)
INSERT [dbo].[Usuarios] ([Id], [Nombre], [Apellidos], [Cedula], [CorreoElectronico], [FechaUltimoAcceso], [Contraseña], [Puntaje]) VALUES (2, N'Kevin', N'Avilla', N'1022922192', N'kevintabuo@gmail.com', CAST(N'2025-02-28T15:50:51.460' AS DateTime), N'1234', 60)
INSERT [dbo].[Usuarios] ([Id], [Nombre], [Apellidos], [Cedula], [CorreoElectronico], [FechaUltimoAcceso], [Contraseña], [Puntaje]) VALUES (4, N'Prueba 2', N'Gonzalez', N'12903478', N'prueba@hotmail.com', NULL, N'sifunciono', 40)
SET IDENTITY_INSERT [dbo].[Usuarios] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Usuarios__531402F357466AF0]    Script Date: 28/02/2025 16:12:23 ******/
ALTER TABLE [dbo].[Usuarios] ADD UNIQUE NONCLUSTERED 
(
	[CorreoElectronico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Usuarios__B4ADFE381E778A13]    Script Date: 28/02/2025 16:12:23 ******/
ALTER TABLE [dbo].[Usuarios] ADD UNIQUE NONCLUSTERED 
(
	[Cedula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Usuarios] ADD  DEFAULT ((0)) FOR [Puntaje]
GO
/****** Object:  StoredProcedure [dbo].[ActualizarUsuario]    Script Date: 28/02/2025 16:12:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ActualizarUsuario]
    @Id INT,
    @Nombre NVARCHAR(100),
    @Apellidos NVARCHAR(150),
    @Cedula NVARCHAR(20),
    @CorreoElectronico NVARCHAR(150),
    @Contraseña NVARCHAR(255)
AS
BEGIN
    UPDATE Usuarios
    SET 
        Nombre = @Nombre,
        Apellidos = @Apellidos,
        Cedula = @Cedula,
        CorreoElectronico = @CorreoElectronico,
        Contraseña = @Contraseña,
        Puntaje = dbo.CalcularPuntajeUsuario(@Nombre, @Apellidos, @CorreoElectronico) -- Recalcula solo para este usuario
    WHERE Id = @Id;
END;

GO
/****** Object:  StoredProcedure [dbo].[InsertarUsuario]    Script Date: 28/02/2025 16:12:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertarUsuario]
    @Nombre NVARCHAR(100),
    @Apellidos NVARCHAR(150),
    @Cedula NVARCHAR(20),
    @CorreoElectronico NVARCHAR(150),
    @Contraseña NVARCHAR(255)
AS
BEGIN
    INSERT INTO Usuarios (Nombre, Apellidos, Cedula, CorreoElectronico, Contraseña, Puntaje)
    VALUES (
        @Nombre, 
        @Apellidos, 
        @Cedula, 
        @CorreoElectronico, 
        @Contraseña,
        dbo.CalcularPuntajeUsuario(@Nombre, @Apellidos, @CorreoElectronico) -- Calcula el puntaje al insertar
    );
END;
GO
/****** Object:  StoredProcedure [dbo].[ValidarUsuario]    Script Date: 28/02/2025 16:12:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ValidarUsuario]
    @CorreoElectronico NVARCHAR(100),
    @Contraseña NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Si las credenciales son correctas
    IF EXISTS (
        SELECT 1 FROM Usuarios WHERE CorreoElectronico = @CorreoElectronico AND Contraseña = @Contraseña
    )
    BEGIN
        -- Actualizar la fecha del último acceso
        UPDATE Usuarios
        SET FechaUltimoAcceso = GETDATE()
        WHERE CorreoElectronico = @CorreoElectronico;

        -- Retornar los datos del usuario con un "Resultado" siempre presente
        SELECT 'OK' AS Resultado, Id, Nombre, Apellidos, Cedula, CorreoElectronico, FechaUltimoAcceso, Puntaje
        FROM Usuarios
        WHERE CorreoElectronico = @CorreoElectronico;
    END
    ELSE
    BEGIN
        -- Retornar un error con "Resultado"
        SELECT 'Error' AS Resultado, 'Credenciales incorrectas' AS Mensaje;
    END
END;
GO
USE [master]
GO
ALTER DATABASE [PruebaTecnica] SET  READ_WRITE 
GO
