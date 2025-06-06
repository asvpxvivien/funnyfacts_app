import 'package:flutter/material.dart';
import 'package:funfacts/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> facts = [
    "Les canards vous regardent peut-être… mais ils ne jugent pas. Enfin, on espère.",
    "Un paresseux peut prendre une semaine pour digérer une feuille. C’est moi avec mes problèmes.",
    "Il est illégal de posséder une seule grenouille en Californie si elle s’échappe d'une course. Oui, ça existe.",
    "Les pieuvres ont trois cœurs… et pourtant elles sont toujours célibataires.",
    "Les vaches ont des meilleurs amis. Et elles dépriment quand elles sont séparées.",
    "Un jour, quelqu’un a essayé de vendre la tour Eiffel. Deux fois. Et il a réussi.",
    "Les wombats font des crottes… carrées. Parfait pour les empiler comme des Lego 🧱💩.",
    "Les chats dorment 70% de leur vie. J'appelle ça un *goal de vie*.",
    "En Suisse, il est illégal de posséder un seul cochon d’Inde. Il lui faut un copain. C’est la loi de l’amitié.",
    "Les dauphins s’appellent par leur prénom. Genre : 'Yo Kevin, on nage ou quoi ?'",
    "Les escargots peuvent dormir pendant trois ans. Ce n’est plus du sommeil, c’est de l’hibernation de compétition.",
    "Une crevette-mante peut frapper avec la vitesse d’une balle de calibre .22. Mike Tyson des mers.",
    "Les papillons goûtent avec leurs pieds. Donc, marcher dans une crotte c’est un vrai repas pour eux.",
    "Un poulpe peut ouvrir un pot de cornichons… et ensuite s’enfuir. Meilleur voleur de pique-nique.",
    "Le mot 'kangourou' vient d’une incompréhension : en gros, ça voulait dire 'je ne comprends pas'.",
    "Il existe un championnat du monde de portage de femme. Si si. Google-le.",
    "La pastèque est un légume. Je sais. Mon monde vient de s’écrouler.",
    "En 1994, une tortue a gagné une course contre un lièvre… dans une vraie compétition. Karma, mon gars.",
    "Le ketchup était vendu comme médicament au 19e siècle. Donc techniquement, j’ai mangé un médicament ce midi.",
    "Les moutons peuvent reconnaître jusqu’à 50 visages. Et moi, j’oublie le nom de quelqu’un 3 secondes après l’avoir entendu.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Funny Facts"),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SettingsScreen();
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: facts.length,
              itemBuilder: (BuildContext, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      child: Text(
                        facts[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(child: Text("Swipe left for more")),
          ),
        ],
      ),
    );
  }
}
