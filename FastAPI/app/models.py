from sqlalchemy import (
    Column,
    String,
    ForeignKey,
    Date,
    Enum,
    Integer,
    Float,
    DateTime
)

from sqlalchemy.dialects.mysql import (
    TINYINT, 
    SMALLINT
)

from sqlalchemy.orm import relationship
from database import Base

class Technician(Base):
    __tablename__ = 'Tecnico'
    
    username = Column(
        String(100),
        primary_key=True,
        name='usuario_tecnico',
        nullable=False
    )
    
    password = Column(
        String(64),
        name='password',
        nullable=False
    )
    
    machine = Column(
        Integer,
        name='maquina',
        nullable=False
    )
    
    name = Column(
        String(100),
        name='nombre',
        nullable=False
    )
    
    lastname = Column(
        String(100),
        name='apellido',
        nullable=False
    )
    
    email = Column(
        String(255),
        name='email',
        nullable=False
    )

class Owner(Base):
    __tablename__ = 'Dueno'
    
    username = Column(
        String(100), 
        primary_key=True, 
        name='usuario_dueno'
    )
    
    password = Column(
        String(64),
        name='password',
        nullable=False
    )
    
    machine = Column(
        Integer,
        name='maquina',
        nullable=False
    )
    
    name = Column(
        String(100),
        name='nombre',
        nullable=False
    )
    
    lastname = Column(
        String(100),
        name='apellido',
        nullable=False
    )
    

class Usuario(Base):
    __tablename__ = 'Usuario'

    email = Column(String(255), primary_key=True)
    password = Column(String(64), nullable=False)
    sexo = Column(Enum('Masculino', 'Femenino'), nullable=False)
    fec_registro = Column(Date, nullable=False)
    username = Column(String(20), nullable=False)
    nombre = Column(String(100), nullable=False)
    apellido = Column(String(100), nullable=False)
    edad = Column(TINYINT, nullable=False)
    fec_nacimiento = Column(Date, nullable=False)
    stripe_customer_id = Column(String(64), nullable=True)

    medidas = Column(
        ForeignKey(
            'Medidas.id_medidas',
            ondelete='CASCADE',
            onupdate='CASCADE'
        ), 
        index=True
    )
    
    cantidades = Column(
        ForeignKey(
            'Cantidades.id_cantidades',
            ondelete='CASCADE',
            onupdate='CASCADE'
        ), 
        index=True
    )
    
    medidas_rel = relationship('Medidas')
    cantidades_rel = relationship('Cantidades')
    
    @property
    def peso_kg(self):
        return self.medidas_rel.peso_kg if self.medidas_rel else None
    
    @property
    def talla_cm(self):
        return self.medidas_rel.talla_cm if self.medidas_rel else None
    
    @property
    def cintura_cm(self):
        return self.medidas_rel.cintura_cm if self.medidas_rel else None
    
    @property
    def cadera_cm(self):
        return self.medidas_rel.cadera_cm if self.medidas_rel else None
    
    @property
    def circ_brazo_cm(self):
        return self.medidas_rel.circ_brazo_cm if self.medidas_rel else None
    
class Cantidades(Base):
    __tablename__ = 'Cantidades'

    id_cantidades = Column(Integer, primary_key=True)
    proteina_gr = Column(TINYINT, nullable=False)
    curcuma_gr = Column(Float, nullable=False)

class Medidas(Base):
    __tablename__ = 'Medidas'

    id_medidas = Column(Integer, primary_key=True)
    imc = Column(Float, nullable=False)
    peso_kg = Column(TINYINT)
    talla_cm = Column(TINYINT, nullable=False)
    cintura_cm = Column(TINYINT, nullable=False)
    cadera_cm = Column(TINYINT, nullable=False)
    circ_brazo_cm = Column(TINYINT, nullable=False)
    fec_actualizacion = Column(Date, nullable=False)

class Alergeno(Base):
    __tablename__ = 'Tipo_Alergeno'
    
    id_tipo_alergeno = Column(Integer, primary_key=True)
    alergeno = Column(String(30), nullable=False)
    
class Proteina(Base):
    __tablename__ = 'Proteina'
    
    id_proteina = Column(Integer, primary_key=True)
    tipo_proteina = Column(Enum('Animal', 'Vegetal'))
    nombre = Column(String(30))
    cont_nutricional = Column(String(30))
    densidad_proteica = Column(Float)
    fec_actualizacion = Column(Date)
    precio = Column(Float)
        
    marca_id = Column(
        ForeignKey(
            'Marca.id_marca',
            ondelete='RESTRICT',
            onupdate='RESTRICT'
        ), 
        index=True,
        name = "marca"
    )
    
    marca_rel = relationship('Marca', foreign_keys = [marca_id])
    
class Marca(Base):
    __tablename__ = 'Marca'
    
    id_marca = Column(Integer, primary_key=True)
    marca = Column(String(100), nullable=False)

class Sabor(Base):
    __tablename__ = 'Sabor'
    
    id_sabor = Column(Integer , primary_key=True)
    sabor = Column(String(100))

class TipoSaborizante(Base):
    __tablename__ = 'Tipo_Saborizante'
    
    id_tipo_saborizante = Column(Integer, primary_key=True)
    tipo_saborizante = Column(String(100))

class Saborizante(Base):
    __tablename__ = 'Saborizante'
    
    id_saborizante = Column(Integer, primary_key=True)
    
    marca_id = Column(
        ForeignKey(
            'Marca.id_marca',
            ondelete='RESTRICT',
            onupdate='RESTRICT'
        ), 
        index=True,
        name = 'marca'
    )
    
    sabor_id = Column(
        ForeignKey(
            'Sabor.id_sabor',
            ondelete='RESTRICT',
            onupdate='RESTRICT'
        ), 
        index=True,
        name = 'sabor'
    )
    
    tipo_saborizante_id = Column(
        ForeignKey(
            'Tipo_Saborizante.id_tipo_saborizante',
            ondelete='RESTRICT',
            onupdate='RESTRICT'
        ), 
        index=True,
        name = 'tipo_saborizante'
    )
    
    cont_calorico = Column(SMALLINT)
    fec_actualizacion = Column(Date)
    porcion = Column(Integer)
    
    marca_rel = relationship('Marca', foreign_keys = [marca_id])
    sabor_rel = relationship('Sabor', foreign_keys = [sabor_id])
    tipo_saborizante_rel = relationship(
        'TipoSaborizante', 
        foreign_keys=[tipo_saborizante_id]
    )
    
    @property
    def sabor(self):
        return self.sabor_rel.sabor if self.sabor_rel else None
        
    @property
    def tipo_saborizante(self):
        return self.tipo_saborizante_rel.tipo_saborizante if self.tipo_saborizante_rel else None

class Curcuma(Base):
    __tablename__ = 'Curcuma'
    
    id_curcuma = Column(Integer, primary_key=True)
    marca_id = Column(
        ForeignKey(
            'Marca.id_marca',
            ondelete='RESTRICT',
            onupdate='RESTRICT'
        ), 
        index=True,
        name = 'marca'
    )
    
    cont_curcuminoide = Column(Float)
    cont_gingerol = Column(Float)
    precauciones = Column(String(500))
    fec_actualizacion = Column(Date)
    precio = Column(Float)
    
    marca_rel = relationship('Marca', foreign_keys = [marca_id])

class AlergenoProteina(Base):
    __tablename__ = 'Alergeno_Proteina'
    
    id_alergeno = Column(Integer, primary_key = True)
    
    proteina = Column(
        ForeignKey(
            'Proteina.id_proteina',
        ),
        index=True
    )
    
    tipo_alergeno_id = Column(
        ForeignKey(
            'Tipo_Alergeno.id_tipo_alergeno',
        ),
        index=True,
        name = 'tipo_alergeno'
    )
    
    proteina_rel = relationship('Proteina')
    alergeno_rel = relationship('Alergeno', foreign_keys=[tipo_alergeno_id])
    
    @property
    def alergeno(self):
        return self.alergeno_rel.alergeno if self.alergeno_rel else None
    
    @property
    def tipo_alergeno(self):
        return self.alergeno_rel.id_tipo_alergeno if self.alergeno_rel else None

class AlergenoUsuario(Base):
    __tablename__ = 'Alergia_Usuario'
    
    id_alergia = Column(Integer, primary_key=True)
    usuario_email = Column(
        ForeignKey(
            'Usuario.email'
        ),
        index = True,
        name = 'usuario'
    )
    
    tipo_alergeno_id = Column(
        ForeignKey(
            'Tipo_Alergeno.id_tipo_alergeno',
        ),
        index=True,
        name = 'tipo_alergeno'
    )
    
    usuario_rel = relationship('Usuario', foreign_keys=[usuario_email])
    alergeno_rel = relationship('Alergeno', foreign_keys=[tipo_alergeno_id])
    
    @property
    def email(self):
        return self.usuario_rel.email if self.usuario_rel else None
    
    @property
    def alergeno(self):
        return self.alergeno_rel.alergeno if self.alergeno_rel else None
    
    @property
    def tipo_alergeno(self):
        return self.alergeno_rel.id_tipo_alergeno if self.alergeno_rel else None

class Compra(Base):
    __tablename__ = 'Compra'
    id_compra = Column(Integer, primary_key=True)
    
    pedido_id = Column(
        ForeignKey(
            'Pedido.id_pedido'
        ),
        index = True,
        name = 'pedido'
    )
    
    monto_total = Column(Float, nullable=False)
    fec_hora_compra = Column(DateTime, nullable=False)
    
    pedido_rel = relationship('Pedido', foreign_keys = [pedido_id])
    
    @property
    def usuario_email(self):
        return self.pedido_rel.usuario_email if self.pedido_rel else None

class Pedido(Base):
    __tablename__ = 'Pedido'
    id_pedido = Column(String(), primary_key=True)
    
    usuario_email = Column(
        ForeignKey(
            'Usuario.email'
        ),
        index = True,
        name = 'usuario'
    )
    proteina_id = Column(
        ForeignKey(
            'Proteina.id_proteina'
        ),
        index = True,
        name = 'proteina'
    )
    curcuma_id = Column(
        ForeignKey(
            'Curcuma.id_curcuma'
        ),
        index = True,
        name = 'curcuma',
        nullable = True
    )
    saborizante_id = Column(
        ForeignKey(
            'Saborizante.id_saborizante'
        ),
        index = True,
        name = 'saborizante'
    )
    maquina_canje_id = Column(
        ForeignKey(
            'Maquina.id_maquina'
        ),
        index = True,
        name = 'maquina_canje',
        nullable=True
    )
    estado_canje = Column(Enum('canjeado', 'no_canjeado'), nullable=False)
    
    fec_hora_canje = Column(DateTime, nullable=True)
    proteina_gr = Column(TINYINT, nullable=False)
    curcuma_gr = Column(Float, nullable=True)
    
    saborizante_rel = relationship('Saborizante', foreign_keys=[saborizante_id])
    proteina_rel = relationship('Proteina', foreign_keys=[proteina_id])
    curcuma_rel = relationship('Curcuma', foreign_keys=[curcuma_id])
    
    @property
    def sabor_id(self):
        return self.saborizante_rel.sabor if self.saborizante_rel else None
    
    @property
    def tipo_proteina(self):
        return self.proteina_rel.tipo_proteina if self.proteina_rel else None
    
class Maquina(Base):
    __tablename__ = 'Maquina'
    id_maquina = Column(Integer, primary_key=True, autoincrement=True)
    ubicacion = Column(String(300), nullable=True)
    
    inv_curcuma = relationship("InvCurcuma", back_populates="maquina_obj", cascade="all, delete-orphan")
    inv_proteina = relationship("InvProteina", back_populates="maquina_obj", cascade="all, delete-orphan")
    inv_saborizante = relationship("InvSaborizante", back_populates="maquina_obj", cascade="all, delete-orphan")

class InvCurcuma(Base):
    __tablename__ = 'Inv_Curcuma'

    id_inv_curcuma = Column(Integer, primary_key=True, autoincrement=True)
    curcuma = Column(Integer, ForeignKey("Curcuma.id_curcuma", onupdate="CASCADE"), nullable=False)
    maquina = Column(Integer, ForeignKey("Maquina.id_maquina", onupdate="CASCADE"), nullable=False)
    cantidad_gr = Column(Float, nullable=False)
    fec_caducidad = Column(Date, nullable=False)
    fec_ult_abasto = Column(DateTime, nullable=False)
    fec_prev_abasto = Column(Date, nullable=True)
    fec_limite_abasto = Column(Date, nullable=True)

    maquina_obj = relationship("Maquina", back_populates="inv_curcuma")
    curcuma_obj = relationship("Curcuma")


class InvProteina(Base):
    __tablename__ = 'Inv_Proteina'

    id_inv_proteina = Column(Integer, primary_key=True, autoincrement=True)
    proteina = Column(Integer, ForeignKey("Proteina.id_proteina", onupdate="CASCADE"), nullable=False)
    maquina = Column(Integer, ForeignKey("Maquina.id_maquina", onupdate="CASCADE"), nullable=False)
    cantidad_gr = Column(Integer, nullable=False)
    fec_caducidad = Column(Date, nullable=False)
    fec_ult_abasto = Column(DateTime, nullable=False)
    fec_prev_abasto = Column(Date, nullable=True)
    fec_limite_abasto = Column(Date, nullable=True)

    maquina_obj = relationship("Maquina", back_populates="inv_proteina")
    proteina_obj = relationship("Proteina")


class InvSaborizante(Base):
    __tablename__ = 'Inv_Saborizante'

    id_inv_sabor = Column(Integer, primary_key=True, autoincrement=True)
    saborizante = Column(Integer, ForeignKey("Saborizante.id_saborizante", onupdate="CASCADE"), nullable=False)
    maquina = Column(Integer, ForeignKey("Maquina.id_maquina", onupdate="CASCADE"), nullable=False)
    cantidad_ml = Column(Integer, nullable=False)
    fec_caducidad = Column(Date, nullable=False)
    fec_ult_abasto = Column(DateTime, nullable=False)
    fec_prev_abasto = Column(Date, nullable=True)
    fec_limite_abasto = Column(Date, nullable=True)

    maquina_obj = relationship("Maquina", back_populates="inv_saborizante")
    saborizante_obj = relationship("Saborizante")

class TipoFallo(Base):
    __tablename__ = 'Tipo_Fallo'

    id_tipo_fallo = Column(Integer, primary_key=True, autoincrement=True)
    nombre_fallo  = Column(String(50), nullable=False)
    descripcion   = Column(String(500), nullable=False)

class Fallo(Base):
    __tablename__ = 'Fallo'

    id_fallo    = Column(Integer, primary_key=True, autoincrement=True)
    maquina     = Column(
        Integer,
        ForeignKey('Maquina.id_maquina', onupdate='CASCADE'),
        nullable=False,
        index=True,
        name='maquina'
    )
    tipo_fallo  = Column(
        Integer,
        ForeignKey('Tipo_Fallo.id_tipo_fallo', onupdate='CASCADE'),
        nullable=False,
        index=True,
        name='tipo_fallo'
    )
    fec_hora    = Column(DateTime, nullable=False)
    descripcion = Column(String(500), nullable=True)

    # relationships
    maquina_rel    = relationship('Maquina', cascade="none")
    tipo_fallo_rel = relationship('TipoFallo', cascade="none")

    @property
    def tipo_fallo_nombre(self) -> str:
        return self.tipo_fallo_rel.nombre_fallo if self.tipo_fallo_rel else None
    
    @property
    def tipo_fallo_descripcion(self) -> str:
        return self.tipo_fallo_rel.descripcion if self.tipo_fallo_rel else None

class HistorialHumedad(Base):
    __tablename__ = 'Historial_Humedad'

    id_humedad = Column(Integer, primary_key=True, autoincrement=True)
    maquina = Column(Integer, ForeignKey('Maquina.id_maquina'), nullable=False)
    humedad = Column(Float, nullable=True)
    fecha_hora = Column(DateTime, nullable=True)