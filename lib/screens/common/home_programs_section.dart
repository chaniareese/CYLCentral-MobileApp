import 'package:flutter/material.dart';
import '/constants.dart';
import '/data/models/program_model.dart';
import 'package:provider/provider.dart';
import '/providers/program_provider.dart';
import './program_detail_screen.dart';

class HomeProgramsSection extends StatelessWidget {
  const HomeProgramsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final programProvider = Provider.of<ProgramProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Explore Our Programs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kGreen1,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all programs page
                },
                child: const Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          child:
              programProvider.isLoading
                  ? const Center(
                    child: CircularProgressIndicator(color: kGreen1),
                  )
                  : programProvider.error != null
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Failed to load programs',
                          style: TextStyle(color: Colors.red[800]),
                        ),
                        ElevatedButton(
                          onPressed: () => programProvider.fetchPrograms(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                  : programProvider.programs.isEmpty
                  ? const Center(child: Text('No programs available'))
                  : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: programProvider.programs.length,
                    itemBuilder: (context, index) {
                      final program = programProvider.programs[index];
                      return _buildProgramCard(context, program);
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildProgramCard(BuildContext context, Program program) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProgramDetailScreen(program: program),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: SizedBox(
                    height: 90,
                    child:
                        program.programHeaderPhoto != null
                            ? Image.network(
                              program.programHeaderPhoto!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                            : Container(color: kMint),
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child:
                        program.logo != null
                            ? Image.network(program.logo!, fit: BoxFit.cover)
                            : Center(
                              child: Text(
                                program.name.length > 1
                                    ? program.name.substring(0, 2).toUpperCase()
                                    : program.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kGreen1,
                                ),
                              ),
                            ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    program.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kGreen1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    program.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
