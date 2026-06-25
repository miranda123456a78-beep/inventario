-- Esquema para la app de inventario en Supabase
-- Ejecuta esto en el SQL Editor del dashboard de Supabase

-- Crear tabla productos
CREATE TABLE IF NOT EXISTS productos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nombre TEXT NOT NULL,
  stock INTEGER NOT NULL DEFAULT 0,
  conteo INTEGER NOT NULL DEFAULT 0,
  ubicacion TEXT NOT NULL DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índice para búsquedas por nombre
CREATE INDEX IF NOT EXISTS idx_productos_nombre ON productos (nombre);

-- Activar Row Level Security
ALTER TABLE productos ENABLE ROW LEVEL SECURITY;

-- Política para permitir operaciones anónimas (CRUD completo)
DROP POLICY IF EXISTS "anon_all" ON productos;
CREATE POLICY "anon_all" ON productos
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);

-- ============================================================
-- Tabla de instantáneas de inventario (snapshots)
-- ============================================================
CREATE TABLE IF NOT EXISTS snapshots_inventario (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  fecha TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  nombre TEXT NOT NULL DEFAULT '',
  datos JSONB NOT NULL DEFAULT '[]',
  total_productos INTEGER NOT NULL DEFAULT 0,
  eri NUMERIC(5,2) NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_snapshots_fecha ON snapshots_inventario (fecha DESC);

ALTER TABLE snapshots_inventario ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_all" ON snapshots_inventario;
CREATE POLICY "anon_all" ON snapshots_inventario
  FOR ALL
  TO anon
  USING (true)
  WITH CHECK (true);
