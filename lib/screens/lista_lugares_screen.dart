import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../estudiante.dart';
import '../providers/lugares_provider.dart';
import 'formulario_screen.dart';

class ListaLugaresScreen extends StatefulWidget {
  const ListaLugaresScreen({super.key});

  @override
  State<ListaLugaresScreen> createState() => _ListaLugaresScreenState();
}

class _ListaLugaresScreenState extends State<ListaLugaresScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LugaresProvider>().cargarLugares();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LugaresProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lugares UIDE'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              estudianteNombre,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ),
        ),
      ),
      body: provider.lugares.isEmpty
          ? const Center(child: Text('No hay lugares registrados aún.'))
          : ListView.builder(
              itemCount: provider.lugares.length,
              itemBuilder: (context, index) {
                final lugar = provider.lugares[index];
                return ListTile(
                  title: Row(
                    children: [
                      Text(lugar.nombre),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          lugar.categoria,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.indigo.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(lugar.descripcion),
                  trailing: IconButton(
                    icon: Icon(
                      lugar.favorito ? Icons.favorite : Icons.favorite_border,
                      color: lugar.favorito ? Colors.red : null,
                    ),
                    onPressed: () {
                      context.read<LugaresProvider>().toggleFavorito(lugar);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormularioScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
