'use client';
import { useState } from 'react';
import type { Registro } from '@/db/schema';
import type { Catalogos } from '@/app/page';
import { colorDeGrupo } from '@/lib/colors';
import { formatoLote } from '@/lib/utils';
import RegistroEditor from './RegistroEditor';

export default function EnProceso({
  registros,
  catalogos,
  onCambio,
}: {
  registros: Registro[];
  catalogos: Catalogos;
  onCambio: () => void;
}) {
  const [abiertos, setAbiertos] = useState<Record<number, boolean>>({});

  if (registros.length === 0) {
    return (
      <div className="card p-10 text-center text-stone-500">
        No hay registros en proceso. Cargá una receta desde el <b>Lector de recetas</b>.
      </div>
    );
  }

  return (
    <div className="grid gap-4 xl:grid-cols-2">
      {registros.map((r) => {
        const color = colorDeGrupo(r.grupoPaciente || r.paciente);
        const abierto = abiertos[r.id] ?? false;
        return (
          <div key={r.id} className="card overflow-hidden" style={{ borderColor: color.border }}>
            {/* Cabecera con color de paciente: nombre GRANDE para evitar cruces */}
            <button
              className="block w-full text-left"
              onClick={() => setAbiertos((a) => ({ ...a, [r.id]: !abierto }))}
              style={{ background: color.bg, borderBottom: `4px solid ${color.border}` }}
            >
              <div className="flex items-center justify-between px-4 py-3">
                <div>
                  <p className="text-2xl font-black uppercase leading-none tracking-tight">
                    {r.paciente || 'SIN NOMBRE'}
                  </p>
                  <p className="mt-1 text-sm font-medium">
                    Fórmula {r.tituloFormula || '—'}
                    {r.indicacion && <> · {r.indicacion}</>} · Lote{' '}
                    <b>{formatoLote(r.lotePrefijo, r.loteNumero)}</b>
                  </p>
                </div>
                <span className="text-2xl">{abierto ? '▾' : '▸'}</span>
              </div>
            </button>

            {abierto && (
              <RegistroEditor registro={r} catalogos={catalogos} colorPaciente={color} onCambio={onCambio} />
            )}
          </div>
        );
      })}
    </div>
  );
}
