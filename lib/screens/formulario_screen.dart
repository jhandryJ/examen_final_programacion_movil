import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../estudiante.dart';
import '../models/lugar.dart';
import '../providers/lugares_provider.dart';

class FormularioScreen extends StatefulWidget {
  const FormularioScreen({super.key});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  String _categoriaSeleccionada = 'Turístico';

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      final nuevoLugar = Lugar(
        nombre: _nombreCtrl.text,
        descripcion: _descripcionCtrl.text,
        lat: miLatBase,
        lng: miLngBase,
        categoria: _categoriaSeleccionada,
      );
      await context.read<LugaresProvider>().agregarLugar(nuevoLugar);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo lugar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Ingresa un nombre' : null,
              ),
              TextFormField(
                controller: _descripcionCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Ingresa una descripción' : null,
              ),
              // Nota del autor: agregué un selector tipo Dropdown para que el usuario elija la
              // categoría del lugar y luego pasé este dato al crear la instancia del Lugar.
              DropdownButtonFormField<String>(
                initialValue: _categoriaSeleccionada,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: const [
                  DropdownMenuItem(value: 'Turístico', child: Text('Turístico')),
                  DropdownMenuItem(value: 'Académico', child: Text('Académico')),
                  DropdownMenuItem(value: 'Servicios', child: Text('Servicios')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _categoriaSeleccionada = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardar,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
