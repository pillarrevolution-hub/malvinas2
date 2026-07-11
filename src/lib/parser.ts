// ---------------------------------------------------------------
// Parser de recetas electrónicas (Colegio de Farmacéuticos de Córdoba)
// Recibe el TEXTO de la receta (extraído del PDF o pegado a mano)
// y devuelve los datos estructurados. Todo es editable después.
// ---------------------------------------------------------------

export type FormulaParseada = {
  titulo: string; // "1", "2", "antioxidante", etc.
  activos: { activo: string; dosis: number; unidad: string }[];
  indicacion: string; // "En ayunas", "A la noche", "mañana"...
  dias: number | null; // "cantidad suficiente para N días"
};

export type RecetaParseada = {
  paciente: string;
  dni: string;
  medico: string;
  matricula: string;
  fechaReceta: string;
  nroReceta: string;
  diagnostico: string;
  formulas: FormulaParseada[];
  advertencias: string[];
};

const RE_ACTIVO = /^[-•*]\s*(.+?):\s*([\d.,]+)\s*(µg|μg|ug|mcg|mg|g|ui|ml|%)\b/i;
const RE_INDICACIONES = /^Indicaciones?\s*:\s*(.+)$/i;
const RE_DIAS = /cantidad\s+suficiente\s+para\s+(\d+)\s*d[ií]as/i;
const RE_LABEL = /^([^\-•*].{0,50}?)\s*:\s*$/; // línea corta que termina en ":"

// Palabras clave ante las que siempre cortamos línea (el texto extraído
// de los PDF del CFC suele venir todo en un solo renglón).
const KEYWORDS_CORTE = [
  'Plan Medico:',
  'APELLIDO Y NOMBRE DNI',
  'DETALLE DE FORMULA MAGISTRAL',
  'Indicaciones:',
  'Cápsulas multicapa',
  'Capsulas multicapa',
  'CÁPSULAS MULTICAPA',
  'DIAGNOSTICO',
  'DIAGNÓSTICO',
  'FIRMA Y SELLOS',
  'MATRICULA PROVINCIAL',
  'ESPECIALIDAD:',
  'ORIGEN APTO',
  'Firma Especialista',
  'FECHA VENCIMIENTO:',
  'Este documento ha sido firmado',
  'Ley 27553',
];

// Convierte el texto "plano" del PDF en líneas lógicas que el parser entiende.
export function segmentarTexto(texto: string): string {
  let t = texto.replace(/\r/g, '');
  // 1) Cortar antes de cada palabra clave
  for (const kw of KEYWORDS_CORTE) {
    t = t.split(kw).join('\n' + kw);
  }
  // 2) Cortar antes de cada ítem de fórmula " - Activo: ..."
  t = t.replace(/\s-\s(?=[^\s])/g, '\n- ');
  // 3) En líneas que no son ítems, cortar después de punto y aparte
  t = t
    .split('\n')
    .map((l) => (l.trim().startsWith('-') ? l : l.replace(/\.\s+/g, '.\n')))
    .join('\n');
  return t;
}

function normalizarUnidad(u: string): string {
  const x = u.toLowerCase().replace('μ', 'µ');
  if (x === 'ug' || x === 'mcg' || x === 'µg') return 'µg';
  if (x === 'ui') return 'UI';
  return x; // mg, g, ml, %
}

function limpiarNombre(s: string): string {
  return s.replace(/\s+/g, ' ').trim();
}

export function parseReceta(textoCrudo: string): RecetaParseada {
  const advertencias: string[] = [];
  const texto = segmentarTexto(textoCrudo);
  const lineas = texto
    .split('\n')
    .map((l) => l.trim())
    .filter((l) => l.length > 0);

  const res: RecetaParseada = {
    paciente: '',
    dni: '',
    medico: '',
    matricula: '',
    fechaReceta: '',
    nroReceta: '',
    diagnostico: '',
    formulas: [],
    advertencias,
  };

  // ---- Encabezado ----
  const mFecha = texto.match(/FECHA\s+RECETA:\s*([\d/-]+)/i);
  if (mFecha) res.fechaReceta = mFecha[1];

  const mNro = texto.match(/\bNRO:\s*(\d+)/i);
  if (mNro) res.nroReceta = mNro[1];

  // Paciente: línea con "APELLIDO, NOMBRE  DNI  RECETA"
  // (puede venir con el encabezado de tabla pegado adelante)
  for (const l of lineas) {
    const sinEncabezado = l.replace(/^APELLIDO\s+Y\s+NOMBRE\s+DNI\s+MAGISTRAL\s*/i, '');
    const m = sinEncabezado.match(/^(.+?)\s+(\d{6,9})\s+RECETA\b/i);
    if (m && !/APELLIDO\s+Y\s+NOMBRE/i.test(m[1])) {
      res.paciente = limpiarNombre(m[1]);
      res.dni = m[2];
      break;
    }
  }
  // Fallback: línea siguiente al encabezado de tabla
  if (!res.paciente) {
    const idx = lineas.findIndex((l) => /APELLIDO\s+Y\s+NOMBRE\s+DNI/i.test(l));
    if (idx >= 0 && lineas[idx + 1]) {
      const m = lineas[idx + 1].match(/^(.+?)\s+(\d{6,9})\b/);
      if (m) {
        res.paciente = limpiarNombre(m[1]);
        res.dni = m[2];
      }
    }
  }
  if (!res.paciente) advertencias.push('No pude detectar el nombre del paciente.');

  // Médico y matrícula
  const mMed = texto.match(
    /MATRICULA\s+PROVINCIAL\s*:?\s*(\d+)\s*\|\s*APELLIDO\s+Y\s+NOMBRE\s*:\s*(.+)/i
  );
  if (mMed) {
    res.matricula = mMed[1];
    res.medico = limpiarNombre(mMed[2]);
  } else {
    advertencias.push('No pude detectar médico/matrícula.');
  }

  // Diagnóstico: entre "DIAGNOSTICO" y "FIRMA Y SELLOS"
  const iDx = lineas.findIndex((l) => /^DIAGN[ÓO]STICO/i.test(l));
  if (iDx >= 0) {
    const partes: string[] = [];
    // ¿"DIAGNOSTICO : texto" en la misma línea?
    const inline = lineas[iDx].replace(/^DIAGN[ÓO]STICO\s*:?\s*/i, '').trim();
    if (inline) partes.push(inline);
    for (let i = iDx + 1; i < lineas.length; i++) {
      if (/^FIRMA\s+Y\s+SELLOS/i.test(lineas[i])) break;
      partes.push(lineas[i]);
    }
    res.diagnostico = limpiarNombre(partes.join(' '));
  }

  // ---- Fórmulas: entre "DETALLE DE FORMULA MAGISTRAL" y "DIAGNOSTICO" ----
  const iDet = lineas.findIndex((l) => /DETALLE\s+DE\s+FORMULA\s+MAGISTRAL/i.test(l));
  const iFin = iDx >= 0 ? iDx : lineas.length;
  const cuerpo = lineas.slice(iDet >= 0 ? iDet + 1 : 0, iFin);

  let actual: FormulaParseada | null = null;
  const cerrar = () => {
    if (actual && actual.activos.length > 0) res.formulas.push(actual);
    actual = null;
  };

  for (const l of cuerpo) {
    const mAct = l.match(RE_ACTIVO);
    if (mAct) {
      if (!actual) actual = { titulo: '', activos: [], indicacion: '', dias: null };
      actual.activos.push({
        activo: limpiarNombre(mAct[1]),
        dosis: parseFloat(mAct[2].replace(',', '.')),
        unidad: normalizarUnidad(mAct[3]),
      });
      continue;
    }
    const mInd = l.match(RE_INDICACIONES);
    if (mInd && actual) {
      actual.indicacion = limpiarNombre(mInd[1]);
      continue;
    }
    const mDias = l.match(RE_DIAS);
    if (mDias) {
      if (actual) actual.dias = parseInt(mDias[1], 10);
      cerrar(); // la línea "cantidad suficiente para N días" cierra la fórmula
      continue;
    }
    const mLabel = l.match(RE_LABEL);
    if (mLabel && !RE_INDICACIONES.test(l)) {
      cerrar();
      actual = { titulo: limpiarNombre(mLabel[1]), activos: [], indicacion: '', dias: null };
      continue;
    }
  }
  cerrar();

  // Numerar títulos vacíos
  res.formulas.forEach((f, i) => {
    if (!f.titulo) f.titulo = `Fórmula ${i + 1}`;
  });

  if (res.formulas.length === 0)
    advertencias.push('No detecté fórmulas con activos. Revisá el texto pegado.');

  return res;
}
