import 'package:flutter/material.dart';

class WorkerCardJobs extends StatelessWidget {
  final String titulo;
  final String pagoSemanal;
  final String frecuenciaPago;
  final String contratista;
  final String ubicacion;
  final String tipoObra;
  final String ultimoPago;
  final String nombreTrabajador;
  final String fechaFinal;
  final String imagenUrl;
  final bool activo;

  const WorkerCardJobs({
    super.key,
    required this.titulo,
    required this.pagoSemanal,
    required this.frecuenciaPago,
    required this.contratista,
    required this.ubicacion,
    required this.tipoObra,
    required this.ultimoPago,
    required this.nombreTrabajador,
    required this.fechaFinal,
    required this.imagenUrl,
    this.activo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ---------- Estado en esquina superior derecha ----------
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: activo ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                activo ? "Activo" : "Finalizado",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // ---------- Contenido principal ----------
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F4E79),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- Columna izquierda ----
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _infoRow("Pago semanal:", pagoSemanal),
                        const Divider(color: Colors.black26, height: 2),
                        const SizedBox(height: 10),
                        _infoRow("Frecuencia de pago:", frecuenciaPago),
                        const Divider(color: Colors.black26, height: 2),
                        const SizedBox(height: 10),
                        _infoRow("Contratista:", contratista),
                        const Divider(color: Colors.black26, height: 2),
                        const SizedBox(height: 10),
                        _infoRow("Ubicación:", ubicacion),
                        const Divider(color: Colors.black26, height: 2),
                        const SizedBox(height: 10),
                        _infoRow("Tipo de Obra:", tipoObra),
                        const Divider(color: Colors.black26, height: 2),
                        const SizedBox(height: 10),
                        _infoRow("Último pago:", ultimoPago),
                        const Divider(color: Colors.black26, height: 2),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  // ---- Columna derecha ----
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        // 🔹 Foto más arriba
                        Transform.translate(
                          offset: const Offset(0, -12),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green, width: 4),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(imagenUrl),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          nombreTrabajador,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "5.0/5.0",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (index) => const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // ✅ Fecha final en una sola línea
                        Text(
                          "Fecha final: $fechaFinal",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ---------- Botón con inner y drop shadow ----------
              Center(
                child: Stack(
                  children: [
                    // 🔸 Drop shadow externo
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xEAEAEAEA),
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Cancelar contrato",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    // 🔸 Inner shadow simulado
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.black.withOpacity(0.1),
                              Colors.transparent,
                              Colors.black.withOpacity(0.1),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- helper fila texto ----------
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
