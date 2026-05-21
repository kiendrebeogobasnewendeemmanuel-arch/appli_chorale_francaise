import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'chant.dart';


class ChantDatabase {
  // Singleton
  static final ChantDatabase instance = ChantDatabase._init();
  static Database? _database;

  ChantDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chants.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, filePath);

  return await openDatabase(
    path,
    version: 2,
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('ALTER TABLE chants ADD COLUMN favori INTEGER NOT NULL DEFAULT 0');
      }
    },
    onCreate: (db, version) async {
      await _createDB(db, version);
      await _insertDefaultChants(db); // ✅ bien placé ici
    },
  );
}


  // Création de la table
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE chants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        langue TEXT NOT NULL,
        titre TEXT NOT NULL,
        contenu TEXT NOT NULL,
        favori INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  //favori
  Future<void> toggleFavori(int id, int currentValue) async {
  final db = await database;

  await db.update(
    'chants',
    {'favori': currentValue == 1 ? 0 : 1},
    where: 'id = ?',
    whereArgs: [id],
  );
}


  // Insérer un chant
  Future<int> insertChant(Chant chant) async {
    final db = await instance.database;
    return await db.insert('chants', chant.toMap());
  }


  // Insérer des chants par défaut si la table est vide

Future<void> _insertDefaultChants(Database db) async {    
var count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM chants WHERE langue = ?', ['Francais']));
if(count == 0) {
   // Chants Français
await db.insert('chants', {
'langue': 'Francais',
'titre': 'A CELUI QUI SERA VAINQUEUR ',
'contenu': '''A celui qui sera vainqueur, et qui me glorifie, 
Je donnerai dit le Seigneur, au ciel l’arbre de vie ! 

🎵Chœur 

Victoire force, honneur et louange,  
Gloire, Gloire, puissance à toi, Jésus ! 

2. Un caillou blanc un nom nouveau, et la manne cachée, 
Lui seront donnés par l’Agneau, sa promesse est scellée !

3. Revêtu d’un vêtement blanc, resplendissant de gloire,  
Sera celui qui par le sang, remporta la victoire ! 

4. Avec Christ, celui qui vaincra, s’assiéra sur son trône, 
Et de ses mains il recevra l’immortelle couronne.''',
    });


      await db.insert('chants', {
  'langue': 'Francais',
  'titre': 'A CELUI QUI SIEGE SUR LE TRONE',
  'contenu': '''
🎵 REFRAIN

À Celui qui siège sur le Trône
Et à l’Agneau,
Soient louange, honneur et gloire ! (x2)
Gloire et force, gloire et force,
Aux siècles des siècles !
Amen ! Amen !
Saint ! Saint ! Saint !
Le Seigneur Dieu Tout-Puissant,
Qui est, qui sera! Saint! Saint! Saint!

🎵 COUPLET 1

Seigneur, Tu es digne de recevoir
Gloire, honneur et puissance,
Car Tu as créé toutes choses
Et c’est par ta volonté qu’elles existent
Et qu’elles ont été créées.
Seigneur, Tu es digne de recevoir
Gloire, honneur et puissance.

🎵 COUPLET 2
Agneau, Agneau,
Tu es digne de prendre le livre
Et d’en ouvrir les sceaux,
Car Tu fus mis à mort
Et Tu nous as rachetés à Dieu par ton sang,
De toutes tribus, langues, peuples et nations.

🎵 PONT

Agneau, Agneau, Tu es digne de prendre le livre  
Et d’en ouvrir les sceaux car Tu fus mis à mort  
Et Tu nous as rachetés à Dieu par ton sang  
De toutes tribus, langues et peuples et nations 
L’Agneau qui fut mis à mort est digne de recevoir 
Puissance, richesse, Sagesse et force,  
Gloire, honneur et louange honneur et louange 
Honneur et louange honneur et gloire et louange. Amen !
'''
});

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'A DIEU SOIT LA GLOIRE',
      'contenu': '''

1/ A Dieu soit la gloire par son grand amour 
Dans mon âme noire s’est levé le jour 
Jésus à ma place mourut sur la croix 
Il m’offre sa grâce et je la reçois 

🎵Refrain :  
Gloire à Dieu, gloire à Dieu terre écoute sa voix ! 
Gloire à Dieu, gloire à Dieu monde réjouis-toi ! 
Oh venez au père Jésus est vainqueur  
Que toute la terre chante en son honneur 

2/ De Jésus, la joie remplit notre cœur 
Qu’importe qu’on voie tout notre bonheur 
Selon sa promesse Jésus changera 
Deuil en Allégresse quand il reviendra. ''',
    });
    
 await db.insert('chants', {
'langue': 'Francais',
'titre': 'ALLELUIA, LA LUMIERE A BRILLE',
'contenu': '''

🎵Refrain : 
alléluia, alléluia, alléluia aujourd’hui la lumière 
a brillé sur la terre alléluia un sauveur nous est né. 
Alléluia, alléluia, alléluia Noël : 

1/ Peuples de l’univers entrez dans la clarté de Dieu, 
alléluia, nations venez, adorer le Seigneur.

2/ Gloire à Dieu dans les cieux et paix sur la terre aux 
hommes alléluia, nations venez, adorer le Seigneur. 

3/ Le verbe s’est fait chair il a habité parmi nous, alléluia, 
nations venez, adorer le Seigneur. ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'AU JUGEMENT ',
      'contenu': '''
Il y aura le jugement mon frère  
Prends courage et fais tout ce qui est bon (bis)

🎵Sop : Au moment du dernier jour 

Tous : tu rendras compte de tout ce que tu as fais 

Au jugement (bis) 
Moi je sais qu’il n’y aura pas d’inquiétude 
Parce que je sais ce que je fais 
Tu sais ce que tu fais, tout le monde saura 
Moi je sais qu’il n’y aura pas d’inquiétude 
''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'AU PIED DE LA SAINTE CROIX',
      'contenu': '''
Au pied de la Sainte croix, jaillit la fontaine 
Du salut que je reçois, grâce souveraine 

Refrain : 
Sainte croix, Sainte croix 
Par toi j’ai la vie 
C’est dans le sang de la croix  
Que je me confie 

Seigneur, le sang de ta croix, mes péchés efface 
Tu me le dis, je le crois, du mal plus de trace 

Prosterné devant la croix, sur le mont calvaire 
Pour toujours je fais mon choix, en toi seul j’espère

M’asseoir au pied de ta croix, est mon doux partage 
C’est là que j’entends ta voix, qui me dit : Courage 

Jusqu’au bout, la Sainte croix, sera ma victoire 
Seule elle ouvre pour ma foi, le ciel et la gloire''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'AU SEUIL DE LA NOUVELLE ANNEE',
      'contenu': '''
🎵Refrain 
Au seuil de la nouvelle année, notre cœur est rempli de foi 
Car c’est Dieu qui nous l’a donnée et c’est lui qui la bénira 
Il a préparé des victoires pour chaque jour, pour chaque instant, 
Il manifestera sa gloire comme le Dieu tout Puissant 

1. Vivre pour Dieu, nous le pouvons  
Car ce n’est plus nous qui vivons 
C’est Jésus Christ qui vit en nous  
Et nous fait triompher partout. 

2. Malgré les lourds nuages noirs,  
Notre cœur est rempli D’espoir 
Pour être cette année qui sait ?  
Jésus viendra nous enlever.

3. Trompette, sonne en Sion,  
Donnez l’alarme sur les monts, 
Criez au monde insouciant 
Le jour de Dieu est imminent.''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'AUPARAVANT',
      'contenu': '''
1. Auparavant le cœur plein d’amertume, 
Je n’osais croire à l’amour du Sauveur ; 
Mais maintenant j’en ai la certitude : 
Mon Jésus m’aime Il a gagné mon cœur 

🎵Refrain : 
Céleste ami ! Je sais que Jésus m’aime, 
Je suis à lui et je l’aime en retour ; 
Hier, aujourd’hui toujours Il est le même. 
Que me faut-il de plus que son amour ? 

2. Auparavant je doutais que la route 
Qu’Il me montrait fût le meilleur chemin 
Mais à la croix, répondant à mes doutes, 
Il a prouvé qu’Il m’aime et veut mon bien 

3. Auparavant ma désobéissance 
Faisait souffrir mon Sauveur constamment ; 
Mais maintenant rempli de confiance, 
C’est mon bonheur de le suivre en tout temps.''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'AUTREFOIS JE SUIVAIS',
      'contenu': '''
1/ Autrefois je suivais mon raisonnement et me confiais qu’en 
mes sentiments, mais maintenant Seigneur, je vis par la foi ; Tu 
satisfais mon cœur je ne veux que toi : 

🎵Refrain : 
Je ne veux que Jésus, en lui seul j’ai foi, 
Je dépends de Jésus, n’est-il pas tout pour moi ! 

2/ Autrefois je portais seul tous mes fardeaux 
Et toujours me chargeais de soucis nouveaux. 
Mais maintenant Seigneur je compte sur Toi, 
Et je marche en vainqueur, car tu vis en moi. 

3/ Autrefois j’agissais sans te consulter 
Ensuite je voulais me justifier 
Mais maintenant Seigneur, Tu choisis ma vie 
Ton humble serviteur l’accepte avec joie.''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'BELLE JERUSALEM',
      'contenu': '''
1/ Belle Jérusalem œuvre des mains de Dieu, ville 
sainte épouse de l’Agneau, place d’or scintillant d’un 
éclat glorieux ! Bientôt nous serons là-haut.

🎵Refrain :Céleste patrie ! O joie infinie, régner avec 
christ dans la cité bénie, là plus de fardeaux mais 
parfait repos, bientôt nous serons là-haut 

2/La cité resplendit de la gloire du père et l’agneau de 
Dieu est son flambeau, les nations marcheront à sa 
vive lumière, bientôt nous serons là-haut. 

3/ Là seront rassemblés ceux qui furent inscrits, dans le 
livre de vie de l’Agneau, tout élu, appelé, rendu saint par 
l’Esprit, Bientôt nous serons là-haut. 

4/ Et dans cette Jérusalem nous régnerons, rois prêtres 
servant le Très-haut, avec lui pour toujours nous 
contemplerons, bientôt nous seront là-haut.''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'C’EST SI BON DE MARCHER AVEC LE SEIGNEUR ',
      'contenu': '''
1/ C’est si bon de marcher avec le Seigneur (2x) 
C’est si bon de marcher toujours un peu plus près du Seigneur 
C’est si bon de marcher avec le Seigneur

2/ C’est si bon de regarder vers le Seigneur (2x) 
De lever les yeux vers lui lorsque s’épaissît la nuit 
C’est si bon de regarder vers le Seigneur 

3/ C’est si bon de s’appuyer sur le Seigneur (2x) 
Dans les bons, les mauvais jours de compter sur son secours 
C’est si bon de s’appuyer sur le Seigneur 

4/ C’est si bon de chanter, louer le Seigneur (2x) 
Le bénir et l’adorer l’acclamer de tout son cœur  
C’est si bon de chanter, louer le Seigneur 

5/ C’est si bon de retrouver ses frères et sœurs (2x) 
Réunis dans l’amour en comptant sur son retour 
C’est si bon de retrouver ses frères et sœurs''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'CE N’EST PLUS MOI QUI VIS ',
      'contenu': '''
Ce n’est plus moi qui vis Alléluia 
C’est Jésus qui vit en moi (bis) 
En moi, en moi c’est Jésus qui vit en moi''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'CE REPOS BENI DE L’AME ',
      'contenu': '''
Ce repos béni de l’âme 
Ah ! Longtemps je l’ai cherché 
Mes efforts toutes mes larmes  
N’ont pas pu me délivrer 

        🎵Refrain 
        Oh! la paix que Jésus donne  
        Me remplit d’adoration 
        A mon Sauveur j’abandonne 
        Tout pour sa bénédiction 

Maintenant j’ouvre la porte  
Jésus entre dans mon cœur 
Pleine victoire il remporte 
Je me livre à mon Sauveur 

          Viens régner, Seigneur j’abdique 
          Je t’acclame Roi des rois 
          Que toute ma vie indique 
          Le disciple de la croix 

L’avenir il en dispose 
Pourquoi dois-je m’inquiéter 
Je ne veux plus autre chose 
Qu’en ta volonté rester''',
    });


     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'LE SEIGNEUR EST MA LUMIERE',
      'contenu': '''
Le Seigneur seul est ma lumière 
Ma délivrance et mon appui 
Qu’est-ce que je craindrai sur la terre 
Puisque ma force est toute en lui 
Le seigneur seul est ma lumière 
Ma délivrance et mon appui''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'CHANTE AVEC ALLEGRESSE ',
      'contenu': '''
Chante avec allégresse (Bass)  
Célébrez l’Eternel 
Louez l’Eternel Dieu (soprane) 
Pour ses bontés infinies 

Louez l’Eternel, car il est bon  
Et sa miséricorde pour nous 
Dure à perpétuité''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'CHANTEZ AU SEIGNEUR',
      'contenu': '''
Chantez au Seigneur un nouveau chant, 
Dansez en son honneur ! 
Chantez au Seigneur un chant nouveau,  
Dansez en son honneur ! 
Jésus est le Roi de gloire,  
Il est le Seigneur des seigneurs  
Jésus est le Roi de gloire,  
Notre libérateur  
''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'CHANTONS UN CHANT NOUVEAUX',
      'contenu': '''
Chantons un chant nouveau à Dieu et levons nos mains  
Poussons des cris de joie (bis)

🎵Soprano 
Dieu est bon (bis) 

🎵Ténor/Bass
Dieu est bon
Il est bon
Dieu est bon (bis) 

🎵Alto 
C’est lui qui te bénit (bis)
C’est lui qui te bénit (bis) ''' ,
});

     await db.insert ('chants', {
      'langue': 'Francais',
      'titre': 'CHRIST A PROMIS D’ETRE AVEC NOUS',
      'contenu': '''
Christ a promis d’être avec nous 
Je m’approche de lui, je m’approche de Lui 
Christ a promis d’être avec nous 
Sa fidélité, durera toujours, sa fidélité, durera toujours 

Jesus promised he will never fail 
I approach him, I approach him 
Jesus promised he will never fail 
His faithfulness is forever more 
His faithfulness is forever more''' ,
});

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'CHRIST LE DIVIN INTERCESSEUR ',
      'contenu': '''1/ Christ le divin intercesseur 
En qui notre âme espère 
Est aussi notre précurseur 
Auprès de Dieu son père 

🎵Refrain 
Oh quel beau jour, quand de nos yeux  
Nous te verrons dans les hauts lieux 
Seigneur Jésus précurseur glorieux 

2/ Tu nous sanctifias pour Dieu  
Par ton œuvre efficace 
Ton entrée au céleste lieu  
Nous prépare la place 

3/ Ceux que tu nommes tes amis  
Sauveur tendre et fidèle 
Seront avec toi réunis  
Dans la gloire éternelle''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'CLOCHE  SONNEZ L’EVANGILe',
      'contenu': '''
1/ Cloche sonnez l’évangile, retentissez en tous lieux, 
Qu’à la campagne de la ville, on entende un chant joyeux, 
Dieu jadis aimant le monde, livra son fils à la mort, 
Que la terre au ciel réponde, en acclamant le Dieu fort. 

🎵Refrain 
Paix salut(bis) en Jésus (bis) 
Cloches résonnez encore 
Paix salut (bis) en Jésus (bis) 
Recevons tous ce trésor. 

2/ Annoncez cloches célestes, la venue d’un Sauveur, 
Dont les bontés manifestes, s’étendent à tout pécheur, 
Répandez dans tout le monde, la nouvelle du pardon, 
Que le ciel la terre et l’onde, répètent l’unisson. 

3/ Sonnez de l’heure suprême, et la honte et le mépris, 
Quand le fils de Dieu lui-même, du salut paya le prix, 
Eclatez en cris de joie, louez le triomphateur, 
La tombe a lâché sa proie, sur la mort Christ est vainqueur. 

4/ Votre voix cloches fidèles, va parcourant l’univers, 
Supplier tous les rebelles, qui gémissent dans les fers, 
De chercher la délivrance, le pardon la liberté, 
En Christ leur seul espérance, pour le temps d’éternité.''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'COMME ILS SONT BEAUX ',
      'contenu': '''
1/  Comme ils sont beaux      
Les pieds de celui qui apporte      
Les bonnes nouvelles, bonnes nouvelles    
Annonçant la paix proclamant des jours de bonheur 
Dieu est Roi (bis)

🎵Refrain : 
Il est Roi (3fois) 
Dieu est Roi 

2/Hors du tombeau       
Jésus est sorti ressuscité           
Il est vivant, Il est vivant           
Il nous a tant aimés voyez c’est là ses pieds percés  
Mais nous savons qu’il est vivant  

🎵Refrain : 
Il est vivant (4fois) 

🎵Solo  
Sachez que : 
Dieu est Roi (4fois)

🎵Solo : Ouh Ouh 
Dieu est Roi, Dieu est Roi 
Il est Roi, Dieu est Roi 
Dieu est Roi a aa, Dieu est Roi a aaaa !!''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'COMMENT COMPRENDRE  ',
      'contenu': '''
1/ Comment comprendre pourquoi Jésus m’aime 
Donnant pour moi sa vie à Golgotha 
Il vint briser de mon péché la chaîne 
Rempli d’amour, je chante Alléluia 

🎵Refrain 
Divin mystère oh grâce inexprimable 
Le Sauveur vint mourir pour moi pécheur 
Me délivre me rend à lui semblable 
Mon Jésus m’aime il habite en mon cœur

2/ Quittant le ciel divine obéissance 
Le fils de Dieu vint mourir sur la croix  
Il me pardonne il me rend l’innocence  
Oh quel amour je l’adore et je crois 

3/ Je sais qu’un jour j’entrerai dans la gloire 
A son image il me transformera, 
Mais maintenant déjà j’ai la victoire 
J’ai part à son héritage ici-bas''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'CONTEMPLER MON DIEU SUR SON TRONE ',
      'contenu': '''
1/ Contempler mon Dieu sur son trône, vivre avec Jésus dans le ciel  
Jeter à ses pieds ma couronne, c’est là le bonheur éternel

🎵Soprano/ Refrain   
Dans le ciel, dans le ciel,  
Vivre avec Jésus dans le ciel, dans le ciel 
Dans le ciel, dans le ciel, dans le ciel  
Dans le ciel c’est là le bonheur éternel  

🎵Alto/ Refrain 
Dans le ciel, dans le ciel, Vivre avec Jésus dans le ciel, 
dans le ciel, dans le ciel, dans le ciel, dans le ciel, dans le ciel c’est là le 
bonheur éternel. 

🎵Ténor/ Refrain
Dans le ciel, dans le ciel, Vivre avec Jésus dans le 
ciel, dans le ciel, dans le ciel, dans le ciel, dans le ciel c’est là le bonheur 
éternel. 

🎵Bass/ Refrain  
Dans le ciel, dans le ciel, Vivre avec Jésus dans le ciel, 
dans le ciel, dans le ciel, dans le ciel, dans le ciel, dans le ciel c’est là le 
bonheur éternel.

2/ Unir ma voix aux chœurs des Anges, bénir, louer Emmanuel, chanter 
à jamais ses louanges, c’est là le bonheur éternel. 

3/ Jouir d’une paix infinie, revoir mes amis dans le ciel, posséder 
l’immortelle vie, c’est là le bonheur éternel. 

4/ Retrouver les saints dans la gloire, près du trône de L’Eternel, 
célébrer la même victoire c’est là le bonheur éternel''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'DANS MON AME SONNE ',
      'contenu': '''
1.Dans mon âme sonne les cloches de joie, 
 la paix de mon cœur qui me la ravira,  
le chemin est dur parfois,  
mais Jésus chante avec moi,  
c’est lui qui me donne les cloches de joie  

🎵Soprano / Alto. Refrain 
Sonne carillon de joie, sonne carillon de 
joie, tout le ciel est dans mon c’est le don de mon sauveur, et c’est lui 
qui sonne les cloches de joie !

🎵Ténor/ Bass. Refrain 
Sonne dans mon cœur, carillon de 
joie, sonne sans relâche carillon de joie, et c’est lui qui sonne 
les cloches de joie ! 

2.Dans sa plénitude l’amour de jésus  
par le Saint-Esprit en moi s’est répandu,  
quand je le laisse régner je suis doux je puis aimer  
c’est alors que sonnent les cloches de joie !

3.Quand surgit l’épreuve comme un ouragan,  
le bras du Seigneur me rend persévérant, 
le ciel peut parâtre noir mais mon cœur est plein d’espoir  
en moi carillonnent les cloches de joie ! 

4.Quel est le mystère d’un pareil bonheur ?  
C’est qu’à jésus christ j’ai donné tout mon cœur,  
l’harmonie, la liberté, c’est de vivre en sainteté,  
alors carillonnent, les cloches de joie ! ''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'DANS MON ÂME UN BEAU SOLEIL BRILLE',
      'contenu': '''
1. Dans mon âme un beau soleil brille ;  
son rayon doux et joyeux 
Répand un éclat qui scintille : 
c’est le sourire de Dieu 

🎵Réfrain 
Oh quel beau soleil dans mon âme : 
Il resplendit, illumine en tout 
A ses rayons mon cœur s’enflamme 
Et je vais chantant partout.

2. Mon cœur était plein de ténèbres 
quand parut un jour nouveau  
Au loin fuyez, ombres funèbres,  
Devant un soleil si beau. 

3. Nuages des plaintes, du doute  
Gaîment je vous dis adieu : 
Voici resplendir sur ma route  
le soleil dans un ciel bleu 

4. O mon cœur, éclate en louanges :  
pour tous le soleil à lui. 
Je serai parmi les phalanges  
qui loueront Dieu jour et nuit. 
''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'DE LA CROIX LA GRACE COULE',
      'contenu': '''
1. De la croix la grâce coule 
Comme un fleuve constamment 

Oh venez, venez en foule             
Un plein pardon vous attend (bis)

2/ Espoir pour le plus coupable  
Espoir pour tout malheureux 

Espoir le Christ adorable                 Bis 
Aux brigands, ouvrit les cieux  (bis)

3/ Oui pour tous la grâce abonde 
A tous le ciel est ouvert  

Pour tous les pécheurs du monde  
Le Rédempteur a souffert (bis)

4/ Crois à sa miséricorde 
Qui dure éternellement 

Pour toi la grâce déborde 
A cette heure en ce moment (bis)
''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'DEBOUT POUR LA SAINTE GUERRE',
      'contenu': '''
I- Débout pour la Sainte guerre 
Le mal est grand encore ; Plus d’un ami ;  
Plus d’un frère sur un chemin de mort. 

🎵Refrain 
En avant ! En avant ! Tous en avant  
Notre chef est tout - Puissant. 
Nos armes sont la prière, l’amour persévérant. 

II- Débout pour la Sainte guerre 
Ranimons notre ardeur. 
Avec la croix pour bannière, qui ne serait vainqueur ? 

III- Débout pour la Sainte guerre 
Soyons unis et fort ! 
Qu’une charité sincère préside nos efforts.

IV- O Dieu pour la Sainte guerre  
Revêts-nous tous en Christ 
Des larmes de la lumière, des dons de ton Esprit ''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'DELIVRE-NOUS O SEIGNEUR ',
      'contenu': '''
Délivre-nous o Seigneur,  
car la fin du monde vient à grand pas (bis) 
Les guerres se multiplient Jésus, 
La famine ne s’abaisse point Jésus 
Les guerres se multiplient Jésus 
Ce sont tes promesses qui s’accomplissent 
Où serons-nous, Où serons-nous,  
Où serons tes enfants oh Jésus(bis)''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'DIEU CHERCHE ENCORE DES HOMMES FORTS',
      'contenu': '''
1/ Dieu cherche encore des hommes forts 
Fidèles jusque dans la mort 
Où sont-ils donc ces cœurs de braves. 
Toujours sans peur aux heures graves. 

🎵Refrain 
Oh fait de nous de vrais vaillants 
Pour toi remplis d’amour brûlant (bis) 

2/ Oui donne-nous la foi des forts 
Que rien n’abatte que rien n’endort 
Vie ou trépas mépris ou gloire 
Qu’importe en Toi c’est la victoire. 

🎵Refrain 
Il règne encore le Dieu vivant  
Et peut défendre ses enfants (bis) 

3/ Pour la couronne des martyrs 
Il faut veiller, prier, souffrir 
Et sur l’étroit sentier des cimes 
Marcher sans craindre les abîmes 

🎵Refrain 
Nos faibles pas Dieu les conduit 
Et sa puissance est notre appui (bis)''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'DIEU TA FIDELITE ',
      'contenu': '''
1/   Dieu ta fidélité va jusqu’aux nues, 
Plus vaste est ton amour que l’horizon, 
Ta tendre main est toujours étendue, 
Inépuisable est ta compassion. 

🎵Refrain : 
Dieu ta fidélité, ton immense bonté 
Se renouvellent envers moi chaque jour. 
Tous mes besoins, c’est ta main qui les comble, 
Dieu ta fidélité dure à toujours. 

2/   Romance du printemps, ou de l’automne, 
Neige hivernale ou saveur de l’été, 
Tout l’univers à ta louange entonne 
L’hymne à ta grâce, à ta fidélité. 

3 /  Ta joie et ton pardon en abondance, 
Ta présence en mon cœur, Ta chaude voix, 
Ta force à chaque pas, ton espérance, 
Par ta fidélité, tout est à moi''',
    });

     await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'DIEU TOUT PUISSSANT ',
      'contenu': '''
1/Dieu Tout puissant, quand mon cœur considère 
Tout l’univers créé par ton pouvoir 
Le ciel d’azur, les éclairs, le tonnerre, 
Le clair matin pour les ombres du soir,  
De tout mon cœur alors s’élève un chant  
Dieu Tout puissant que tu es grand !2x

2/ Quand par les bois, ou la forêt profonde, 
J’erre et j’entends tous les oiseaux chanter, 
Quand sur les monts la source avec son onde 
Livre au zéphyr son chant doux et léger, 
Mon cœur heureux s’écrie à chaque instant : 
O Dieu d’amour que tu es grand !2x 

3/Mais quand je songe, ô sublime mystère 
Qu’un Dieu si grand a pu penser à moi, 
Que son cher fils est devenu mon frère 
Et que je suis l’héritier du grand Roi 
Alors mon cœur redit la nuit le jour :  
Que tu es bon, ô Dieu d’amour 2x

4/Quand mon Sauveur, éclatant de lumière, 
Se lèvera de son trône éternel, 
Et que laissant les douleurs de la terre, 
Je pourrai voir les splendeurs de Son ciel, 
Je redirai dans son divin séjour : 
Rien n’est plus grand que ton amour.2x''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'DIEU TU ES BON',
      'contenu': '''
Dieu tu es bon, oh mon Dieu tu es bon (bis) 
Je te bénirai, 
je t’exalterai, 
je te célébrerai toute ma vie (bis) 
Oh je te confie aussi ma vie O Dieu''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'DITES-LE FORT',
      'contenu': '''
1/Entendez tous l’appel, adorez l’Eternel, 
Vous familles de la terre, célébrez ce que Dieu a fait 

🎵Refrain  
Dites-le fort, encore plus fort, 
Annoncez ce que Dieu a fait. 
Dites le fort, louez son nom. 
Que la terre se réjouisse,  
Car le Seigneur règne. 

2/ Vaste et grand est l’amour envoyé du haut des cieux. 
Le Fils de Dieu pour nous est mort. Ressuscité, il vit encore.

3/ Quand son nom retentit, de la nature un chant jaillit,  
Car il vient juger la terre avec justice et vérité. 
Dites-le fort, plus fort, annoncez ce que Dieu a fait. (2x) 
Jésus, Jésus, Jésus.  

Dites-le fort, plus fort 
Annoncez ce que Dieu a fait. 
Car le Seigneur règne  2x 
Car le Seigneur règne.''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'DOIS-JE PARTIR LES MAINS VIDES ',
      'contenu': '''
1. Dois-je partir les mains vides pour le séjour éternel 
Et quitter ces lieux arides sans une âme pour le ciel ? 

🎵Refrain   
Oui faut-il que les mains vides  
Je rencontre mon Sauveur ?  
Pendant que des cœurs avides  
Cherchent en vain le bonheur ? 

2. Jésus a sauvé mon âme  
De la mort je n’ai plus peur 
Mais ce que mon cœur réclame  
c’est un don pour mon Sauveur 

3. Si je pouvais de la vie  
recommencer le chemin, 
Je n’aurais plus qu’une envie : 
Semer partout le bon grain. 

4. Pour vous aussi, l’heure passe.  
Oh ! Pendant qu’il est temps 
Annoncez de Dieu la grâce 
Aux cœurs contrits repentants ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'DOUCE NUIT ',
      'contenu': '''
1- Douce nuit, sainte nuit !  
Dans les cieux ! L’astre luit, 
Le mystère annoncé s’accomplit. 
Cet enfant sur la paille endormi, 
C’est l’amour infini,  
C’est l’amour infini ! 

2- C’est vers nous, qu’Il accourt  
En un don, sans retour 
De ce monde ignorant de l’amour, 
Où commence aujourd’hui son séjour, 
Qu’Il soit Roi pour toujours,  
Qu’Il soit Roi pour toujours. 

3- Paix à tous, Gloire au ciel,  
Gloire au Dieu Tout Puissant 
Qui pour nous en ce jour de Noël, 
Envoya  le Sauveur éternel 
Qu’attendait Israël,  Qu’attendait Israël ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'DU ROCHER DE JACOB',
      'contenu': '''1) Du rocher de Jacob, toute l’œuvre est parfaite 
Ce que sa bouche a dit, sa main l’accomplira

Réfrain : 
Alléluia, Alléluia, car il est notre Dieu, car il est notre Dieu, 
Car il est notre Dieu, notre haute retraite.

2)  C’est pour l’éternité que le Seigneur nous aime ; 
Sa grâce en notre cœur jamais ne cessera. 

Réfrain : 
Alléluia, Alléluia, car il est notre Dieu, car il est notre Dieu, 
Car il est notre Dieu, notre bonheur suprême.

3) De tous nos ennemis il sait quel est le nombre ; 
Son bras combat pour nous et nous délivrera. 

Réfrain : 
Alléluia, Alléluia, les méchants devant lui,  
Les méchants devant lui, les méchants devant lui  
S’enfuiront comme une ombre. 

4) Nos corps mortels aussi connaîtront sa victoire, 
Nous savons que bientôt, il les transformera ; 

Réfrain : 
Alléluia, Alléluia, pour nous ses rachetés, pour nous ses 
rachetés, pour nous ses rachetés, la mort se change en gloire. 

5) Louons donc l’Eternel, notre Dieu, notre Père ; 
Le Seigneur est pour nous : contre nous qui sera ? 

Réfrain :
Alléluia, Alléluia, triomphons en Jésus, triomphons en 
Jésus,Triomphons en Jésus et vivons pour lui plaire.''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'ECOUTEZ LE CHANT DES ANGES',
      'contenu': '''
1) Ecoutez le chant des anges  
Vient d’éclater dans les airs. (bis) 
Joignons aussi nos louanges  
A leurs sublimes concerts. (Bis) 
Gloire à Dieu paix sur la terre  
Aujourd’hui le Christ est né.

🎵Refrain : Jésus c’est notre frère  
Un Sauveur nous est donné ; est donné 

2/Son palais est une étable, une crèche est son berceau (bis) 
Et pourtant c’est l’admirable, c’est le fils du Dieu Très haut (bis) 
Il vient à nous débonnaire et de grâce couronné. 

3/Avec vous bergers et mages, aux pieds de notre Sauveur (bis) 
Nous déposons nos hommages, nous lui donnons notre cœur 
(bis) 
Tout son peuple sur la terre dit, avec nous prosternés 

4/Que toute langue bénisse le Saint nom d’Emmanuel, (bis) 
Et qu’en tout lieu retentisse ce cantique solennel ! Gloire à 
Dieu, paix sur la terre ! Aujourd’hui le Christ est né''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'ELEVEZ-VOUS, PORTES DES CIEUX ',
      'contenu': '''
1. Elevez-vous portes des cieux, 
Voici le Roi de gloire, va revenir 
Dans les hauts lieux, couronné de victoire. 

Mais quel Roi glorieux (Ténor + Basse) 
Si doux, si bienveillant, (ensemble) 
Quel est ce Roi victorieux (Ténor + Basse) 
Quel est ce prince triomphant ?(ensemble) 
C’est le Dieu Saint, le Roi des cieux (soprano+Alto+basse)

L’Eternel Tout puissant. C’est le Dieu Saint (ensemble) 
Le Roi des cieux, L’Eternel Tout puissant. 

🎵Refrain : 
Alléluia !Alléluia !Alléluia !Alléluia !Alléluia ! 
Amen !Amen !Amen ! 

2. Elevez-vous dans les hauts cieux 
Portes de la victoire, laissez entrer  
victorieux, le prince de la gloire. 

Mais quel Roi glorieux (Ténor + Basse) 
Si doux, si bienveillant, (ensemble)  
Quel est ce Roi victorieux (Ténor + Basse) 
Quel est ce prince triomphant ? (ensemble) 
C’est le Dieu Saint et glorieux (soprano+Alto+basse) 

Le Sauveur Tout puissant. (Ensemble) 
C’est le Dieu Saint et glorieux  
Le Sauveur Tout puissant.''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'EN CET INSTANT SOLENNEL',
      'contenu': '''
EN CET INSTANT SOLENNEL OU SE FONDE UNE FAMILLE 
DEVANT TOI PERE ETERNEL CREATEUR DE TOUTE VIE 
TU VIENS METTRE DE TA MAIN SUR CE PACTE UN SCEAU DIVIN (BIS) 

TU FONDAS TOI-MEME UN JOUR DES L’AURORE DE CET AGE 
POUR PROTEGER NOTRE AMOUR LE PACTE DU MARIAGE 
TU GARDERAS CES EPOUX UNIS EN TOI JUSQU’AU BOUT (BIS) 

DANS LES BONS ET MAUVAIS JOURS TU SERAS POUR EUX UN PERE 
REMPLISSANT LEUR CŒUR D’AMOUR DE LOUANGE ET DE LUMIERE 
TA PRESENCE A LEUR COTE SERA LEUR FELICITE (BIS) 

TU SERAS DANS LEUR FOYER EN TOUT TEMPS L’HOTE INVISIBLE 
TOUJOURS PRET A LEUR PARLER DANS LA PRIERE ET LA BIBLE 
OH ! QU’HEUREUX EST SOUS LA LOI DU FOYER DONT TU ES ROI !(BIS) 
''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'ENTRE TES MAINS J’ABANDONNE ',
      'contenu': '''1 /  Entre tes mains j’abandonne  
Tout ce que j’appelle mien 
Oh ne permets à personne  
Seigneur, d’en reprendre rien !

Réfrain :
 Oui, prends tout Seigneur ! (2fois) 
Entre tes mains j’abandonne 
Tout avec bonheur. 

2/  Je n’ai pas peur de te suivre 
Sur le chemin de la croix 
C’est pour toi que je veux vivre, 
Je connais, j’aime ta loi. 

Réfrain : 
Oui, prends tout Seigneur ! (2fois) 
Sans rien garder, je te livre 
Tout avec bonheur. 

3/  Tu connais mieux que moi- même 
Tous les besoins de mon cœur  
Et, pour mon bonheur suprême 
Tu peux me rendre vainqueur

Réfrain : 
Oui, prends tout Seigneur ! (2fois) 
Je ne vis plus pour moi- même  
Mais pour mon Sauveur 

4/  Prends mon corps et prends mon âme, 
Que tout en moi soit à Toi ! 
Que par ta divine flamme 
Tout mal soit détruit en moi ! 

Réfrain : 
Oui, prends tout Seigneur ! (2fois) 
Prends mon corps et prends mon âme, 
Règne sur mon cœur. 
''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'GLOIRE A DIEU',
      'contenu': '''
🎵Soprane :
Gloire à Dieu, Gloire à Dieu, dans les hauts cieux 
Gloire à Dieu, Gloire à Dieu, Gloire à Dieu, dans les hauts cieux 
Et paix sur terre aux hommes qu’il agrée 
Et paix sur terre aux hommes qu’il agrée, 
Gloire à Dieu, Gloire à Dieu, dans les hauts cieux 
Et paix sur terre, Et paix, Et paix, Et paix, Et paix, Et paix sur la terre 
aux hommes, paix sur la terre aux hommes qu’il agrée 

🎵Alto :
Gloire à Dieu, Gloire à Dieu, dans les hauts cieux 
Gloire à Dieu, Gloire à Dieu, Gloire à Dieu, dans les hauts cieux 
Et paix sur terre aux hommes qu’il agrée 
Et paix sur terre aux hommes qu’il agrée, 
Gloire à Dieu, Gloire à Dieu, dans les hauts cieux 
Et paix sur terre, Et paix sur terre aux hommes qu’il agrée 
Et paix, Et paix, Et paix, Et paix sur terre aux hommes qu’il agréeTénor 
Gloire à Dieu, Gloire à Dieu, dans les hauts cieux 
Et paix sur terre, Gloire à Dieu, Gloire à Dieu, Gloire à Dieu, Gloire à 
Dieu, dans les hauts cieux, Et paix sur terre, Et paix sur terre aux 
hommes qu’il agrée 
Et paix sur terre aux hommes, paix aux hommes qu’il agrée,  
Gloire à Dieu, dans les hauts cieux 
Et paix sur terre, Et paix sur terre aux hommes qu’il agrée 
Et paix, Et paix, Et paix sur terre aux hommes qu’il agrée 

🎵Bass :
Et paix sur terre, Gloire à Dieu, Gloire à Dieu, Gloire à Dieu, dans 
les hauts cieux, Et paix sur terre, Et paix sur terre aux hommes, Et paix 
sur la terre aux hommes qu’il agrée 
Gloire à Dieu, Gloire à Dieu, dans les hauts cieux 
Et paix sur terre, Et paix, Et paix, Et paix, Et paix sur la terre aux 
hommes qu’il agrée''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'GLOIRE A JESUS-CHRIST ',
      'contenu': '''
Gloire à, Gloire à Jésus – Christ,  
Gloire à Jésus – Christ, c’est lui le Sauveur (BIS) 
Il est la lumière, le salut promis à nous tous (BIS) 
Gloire à…''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'GLOIRE SOIT A DIEU ',
      'contenu': '''
1/ Gloire soit à Dieu, Gloire soit à Dieu, Gloire soit à Dieu dans 
les hauts cieux et paix sur terre, sagesse aux hommes, gloire à 
Dieu dans hauts cieux 

🎵Soprano/ Alto :
 Quelle céleste voix, quelle voix remplit les cieux, 
doux concert du matin, perce l’oreille tout doucement, 
transporté dans la mélodie douce et tranquille. 

🎵Basse : 
Ecoutez chanter les anges 

Gloire soit à Dieu dans les hauts cieux et paix sur terre, sagesse 
aux hommes, gloire à Dieu dans hauts cieux 
Ecoutez les anges chanter gloire à Dieu, gloire soit à Dieu dans 
les hauts cieux et paix sur terre, sagesse aux hommes, gloire à 
Dieu dans hauts cieux 

2/ Gloire soit à Dieu, Gloire soit à Dieu dans les hauts cieux et 
paix sur terre, et paix sur terre, Bienveillance envers les 
hommes. Ecoutez ces armées concert remplis les airs. Concert 
en Jésus Christ qui vivifie les cœurs. Dans la douceur chantez, 
chantez l’immense amour du Dieu Sauveur.  
Magnifiez le nom du Dieu glorieux c’est le vrai Dieu qui nous 
Sauve par son fils unique Jésus.  
Allons à Jésus, allons à Jésus, lui confier nos joies et nos peines 
Jésus vous dit venez à moi, allons à lui le Sauveur !''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'GRAND DIEU NOUS TE BENISSONS ',
      'contenu': '''
1/ Grand Dieu nous te bénissons 
Nous célébrons tes louanges ! 
Eternel, nous t’exaltons, 
De concert avec les anges, 
Et prosternés devant toi, 
Nous t’adorons, ô grand roi ! 

2/ Saint, Saint, Saint est l’éternel 
Le Seigneur, Dieu des armées ! 
Son pouvoir est immortel ; 
Ses œuvres, partout semées, 
Font éclater sa grandeur, 
Sa majesté, sa splendeur. 

3/ Sauve ton peuple, Seigneur, 
Et bénis ton héritage ! 
Que ta gloire et ta splendeur  
Soient à jamais son partage ; 
Conduis – le par ton amour  
Jusqu’au céleste séjour !

4/ Puisse ton règne de paix 
S’étendre sur tout le monde ! 
Dès maintenant, et à jamais, 
Que, sur la terre et sur l’onde ! 
Tout genou soit abattu 
Au nom du Seigneur Jésus ! 

5/ Gloire soit au Saint-Esprit !  
Gloire soit à Dieu le Père ! 
Gloire soit à Jésus-Christ, 
Notre sauveur, notre frère ! 
Son immense charité ! 
Dure à perpétuité. 
''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'HALLELUJAH',
      'contenu': '''
🎶HALLELUJAH (Alto) 
Alléluia! Alléluia! Alléluia! Alléluia! Allé-luia! 
Alléluia! Alléluia! Alléluia! Alléluia! Allé-luia! 
Dieu tout puissant et Roi du ciel règne 
Alléluia Alléluia Alléluia  Alléluia 
Dieu tout puissant et Roi du ciel règne 
Alléluia Alléluia  Alléluia  Alléluia 
Alléluia! Alléluia! Alléluia! Alléluia! Alléluia! 
Alléluia Allé-luia Alléluia Alléluia 
Dieu tout puissant et Roi du ciel règne, Alléluia Allél-uia 
Toujours Il règnera, Il règnera, 
Triomphe honneur et gloire soit au christ le Roi des rois  
Il règnera au siècle des siècles 
Triomphe et gloire au siècle des siècles  
Gloire à Dieu, Au Roi des rois  
Triomphe et gloire !Alléluia! Alléluia! 
Triomphe et gloire !Alléluia! Alléluia! 
Triomphe et gloire !Alléluia! Alléluia! 
Gloire à Dieu, Au Roi des rois  
Triomphe honneur au Roi des rois Il règnera,  
seul Dieu au siècle des siècles 
Au Seigneur, Triomphe et gloire,  
Au Roi des rois Alléluia! Alléluia 
Il règnera dans les siècles des siècles 
Seul vrai Dieu et Roi des rois (x2) 
Triomphe et gloire !Triomphe et gloire ! 
Alléluia Alléluia Alléluia Alléluia Alléluia 
Alléluia Alléluia Alléluia Alléluia Alléluia

🎶HALLELUJAH (Ténor) 
Alléluia !Alléluia ! Alléluia ! Alléluia !Alléluia 
Alléluia ! Alléluia ! Alléluia !Alléluia !Alléluia 
Dieu tout puissant et Roi du ciel règne ! 
Alléluia ! Alléluia ! Alléluia ! Alléluia 
Dieu tout puissant et Roi du ciel règne ! 
Alléluia ! Alléluia ! Alléluia ! Alléluia ! 
Alléluia ! Alléluia ! Alléluia ! Alléluia ! Alléluia ! 
Dieu tout puissant et Roi du ciel règne ! 
Alléluia Alléluia !Alléluia ! 
Dieu tout puissant et Roi du ciel règne. Alléluia ! 
Toujours il règnera. Il règnera. 
Triomphe honneur et gloire soit au Christ le Roi des rois. 
Il règnera au siècle des siècles.  
Il règnera, il règnera, il règnera !il règnera ! 
Gloire à Dieu, Triomphe, Triomphe et gloire Alléluia !Alléluia ! 
Triomphe et gloire, Alléluia !Alléluia Triomphe et gloire, 
Alléluia !Alléluia 
Triomphe et gloire, Alléluia !Alléluia Triomphe et gloire, 
Alléluia !Alléluia 
Gloire à Dieu, Au Roi des rois !  
Triomphe honneur Au Roi des rois 
Il règnera au siècle des siècles 
Au Seigneur, aux Rois des rois 
Seul Dieu il règnera dans siècle des siècles 
Seul vrai Dieu et Roi des rois, Seul vrai Dieu et Roi des rois. 
Il règnera dans les siècles des siècles 
Triomphe et gloire ! Triomphe et gloire ! 
Alléluia Alléluia Alléluia Alléluia Alléluia 
Alléluia Alléluia Alléluia Alléluia Alléluia

🎶HALLELUJAH (Bass)  
Alléluia , Alléluia, Alléluia, Alléluia, Alléluia 
Alléluia, Alléluia, Alléluia, Alléluia, Alléluia 
Dieu tout puissant et Roi du ciel règne 
Alléluia Alléluia, Alléluia, Alléluia 
Dieu tout puissant et Roi du ciel règne 
Alléluia Alléluia, Alléluia, Alléluia, Alléluia 
Dieu tout puissant et Roi du ciel règne, Alléluia ! Alléluia ! 
Alléluia Alléluia, Alléluia, Alléluia, Alléluia, Alléluia, Alléluia 
Toujours Il règnera, Il règnera. 
Triomphe honneur et gloire soit au christ le Roi des rois  
Il règnera au siècle des siècles, au siècle des siècles 
Il règnera, Il règnera Roi des rois 
Triomphe et gloire, Triomphe et gloire, Triomphe et gloire, Triomphe ! 
Triomphe et gloire, Alléluia, Alléluia! Triomphe et gloire Alléluia! 
Alléluia! 
Triomphe et gloire, Alléluia Alléluia! Triomphe et gloire Alléluia! Alléluia! 
Triomphe et gloire Alléluia ! Alléluia 
Gloire à Dieu, Au Roi des rois….. 
Triomphe honneur, Au Roi des rois Il règnera au siècle des siècles 
Au Seigneur, Triomphe et gloire, Au Roi des rois Alléluia! Alléluia ! 
Seul Dieu il règnera dans siècle des siècles 
Seul vrai Dieu et Roi des rois, Seul vrai Dieu et Roi des rois. 
Il règnera aux siècles des siècles seul maître. 
Triomphe et gloire ! Triomphe et gloire ! 
Alléluia, Alléluia, Alléluia, Alléluia, Alléluia 
Alléluia, Alléluia, Alléluia, Alléluia, Alléluia 

🎶HALLELUJAH (Soprano) 
Alléluia, Alléluia Alléluia Alléluia, Alléluia 
Alléluia, Alléluia Alléluia, Alléluia, Alléluia 
Ton Zusoba sê toê fâan dit a naam ! 
Alléluia Alléluia Alléluia Alléluia 
Alléluia Alléluia Alléluia Alléluia 
Ton Zusoba sê toê fâan dit a naam  
Alléluia Alléluia Alléluia Alléluia Alléluia ! Alléluia 
Alléluia Alléluia Alléluia Alléluia Alléluia ! Alléluia 
Alléluia ! Alléluia 
Dunia fâan pida ne Wênnaam waogre 
Tongre waogre naam la ziir be ne Christ 
Dim damb Dima  
Bam na di naam wakat sê ka seta! 
Waog Wênnam, dim dam Dima 
Waog Wênnam, dim dam Dima 
Waog Wênnam, dim dam Dima, 
Bam na di naam Tongere la waogere 
Bam na di naam wakat sê ka seta! 
Tongere la waogere Alléluia ! Alléluia 
Wênaam, la Bam na di naam wakat sê ka seta! 
Sid Wênaam, dim damb Dim 
Sid Wênaam, dim damb Dim 
la Bam na di naam wakat sê ka seta! 
Sid Wênaam, Dim damb Dim 
Alléluia Alléluia Alléluia Alléluia 
Alléluia 

🎶HALLELUJAH (alto) 
Alléluia Alléluia Alléluia Alléluia Alléluia 
Alléluia Alléluia Alléluia Alléluia Alléluia 
Ton Zusoba sê toê fâan di ta naam ! 
Alléluia Alléluia Alléluia Alléluia 
Alléluia Alléluia Alléluia Alléluia 
Alléluia Alléluia Alléluia Alléluia Alléluia !  
Ton Zusoba sê toê fâan dita naam !Alléluia Alléluia 
Dunia fâan pida ne Wênnaam waogre 
Tongre waogre naam la ziir be ne Christ 
dim damb Dima  
Bam na di naam wakat sê ka seta!  
Tongere la waogre wakat sê ka seta 
Waog Wênnam, dim dam Dima 
Tongere la waogre Alléluia Alléluia 
Tongere la waogre Alléluia Alléluia 
Tongere la waogre Alléluia Alléluia !  
Waog Wênnam dim dam Dima, 
Bam na di naam, Wênnaamwakatsê ka sata 
Zusoba ! Tongere la waogeredim dam dima, 
Alléluia ! Alléluia 
la Bam na di naamwakatsê ka sata! 
Sid Wênaam, Dim dambdim 
Sid Wênaam, Dim dambdim 
la Bam na di naamwakatsê ka sata! 
Tongere la waogere,Tongere la waogere 
Alléluia AlléluiaAlléluiaAlléluia 
Alléluia 

🎶HALLELUJAH (Tenor) 
Alléluia Alléluia Alléluia Alléluia Alléluia 
Alléluia Alléluia Alléluia Alléluia Alléluia 
Ton Zusobasêtoêfâan di ta naam ! 
Alléluia Alléluia Alléluia Alléluia 
Ton Zusobasêtoêfâan di ta naam  
Alléluia Alléluia Alléluia Alléluia 
Alléluia ! Alléluia AlléluiaAlléluiaAlléluia 
Ton Zusobasêtoêfâan di ta naam  
Alléluia AlléluiaAlléluia 
Ton Zusobasêtoêfâan di ta naam Alléluia 
Duniafâan pi da ne Wênnaam waogre 
Tongrewaogrenaam la ziirbe ne Christ 
Dim damb Dima  
Bam na di naam wakatsê ka sata! 
Bam na di naam Bam na di naam 
Bam na di naam Bam na di naam  
waogWênnam,TongereTongere la waogere Alléluia Alléluia 
Tongere la waogere, tongere la waogere, tongere la waogere, 
tongere la waogere, AlléluiaAlléluia 
tongere la waogere, AlléluiaAlléluia 
tongere la waogere, AlléluiaAlléluia 
waogWênnam, dim dam dima 
tongerewaogere dim dam dima 
Bâmna di naam wakatsê ka seta 
Zusoba,Dim damb dim 
Wênnam la bam na di naam wakatsê ka sata 
Sid wênaam, dim dam dima 
Sid wênaam, dim dam dima 
La Bâm na di naamwakatsê ka seta 
Tongere la waogere, tongere la waogere 
Alléluia AlléluiaAlléluiaAlléluiaAlléluia 

🎶HALLELUJAH (Bass) 
AlléluiaAlléluiaAlléluiaAlléluiaAlléluia 
AlléluiaAlléluiaAlléluiaAlléluiaAlléluia 
Ton Zusobasêtoêfâan di ta naam ! 
Alléluia AlléluiaAlléluiaAlléluia 
Ton Zusobasêtoêfâan di ta naam  
Alléluia AlléluiaAlléluiaAlléluia Alléluia ! 
Ton Zusobasêtoêfâan di ta naam Alléluia 
AlléluiaAlléluiaAlléluiaAlléluiaAlléluiaAlléluiaAlléluia 
Duniafâan pi da ne neWênnaamwaogre 
Tongrewaogrenaam la ziirbe ne Christ 
Dim damb Dima  
Bam na di naamwakatsê ka sata!Wakatsê ka sata! 
Bam na di naam 
Bam na di naam 
Dim dambdim, 
Tongere la waogere, tongere la waogere, tongere la 
waogere, 
tongere la waogere, Alléluia Alléluia 
tongere la waogere, Alléluia Alléluia 
tongere la waogere, Alléluia Alléluia 
waogWênnam, dim dam dima 
tongerewaogeredim dam dima 
Bâm na di naamwakatsê ka seta 
Zusoba, tongere la waogere 
Dim dambdim, 
Alléluia Alléluia 
Wênnam la bam na di naamwakatsê ka sata 
Sid wênaam, dim dam dima 
Sid wênaam, dim dam dima 
Bâm na di naamwakatsê ka setaya sida 
Tongere la waogere, tongere la waogere 
Alléluia AlléluiaAlléluiaAlléluia 
Alléluia

''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'HOSANNA ',
      'contenu': '''1) Hosanna béni soit ce Sauveur débonnaire 

2) qui vers nous, plein d’amour descend du sein du père  
Béni soit le Seigneur qui vient des plus hauts cieux 
Apporter aux humains un salut glorieux un salut glorieux

3) Hosanna béni soit le prince de la vie,  
que de joie en son nom notre âme soit ravie, 
Qu’en des accents nouveaux elle n’éclate aujourd’hui,  
Que tout enfant de Dieu tressaille devant lui  

4) Hosanna béni soit cet ami charitable,  

5) que le plus grand pécheur va trouver favorable, 
Humble et sans apparat sous notre humanité  
Il a voilé l’éclat de sa divinité, de sa divinité, 

6) Hosanna béni soit Jésus notre justice  
pour nous pauvres pécheurs, Il s’offre en sacrifice  
ce fils du Dieu très-haut ce puissant Roi des Rois 
Pour nous ouvrir le ciel vient mourir sur la croix 

7) Hosanna racheté peuple libre et fidèle 
répétons hosanna plein d’une ardeur nouvelle,  
C’est notre hymne d’amour c’est notre chant de paix,  
Que ce chant parmi nous, retentisse à jamais, ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'HYMNE DU CENTENAIRE ',
      'contenu': '''
1. O Dieu ta grandeur et ta fidélité 
Ont rayonné sur le Burkina Faso 
Par l’œuvre des missionnaires tu as montré 
Ton amour éternel pour notre nation 

🎵Refrain 1 :
Et ton peuple est debout 
Assemblé dans l’unité 
Pour proclamer tout l’Evangile 
Revêtu de l’Esprit-Saint.

2. Cent années sont bien passées et jusqu’ici 
Ta parole est proclamée pour tous les peuples 
Tout un siècle bien compté et nous rendons  
La gloire à l’Eternel le Dieu souverain. 

🎵Refrain 2 : 
Obéissant à ta voix  
Pour le combat de la foi 
Pour le Burkina Faso 
Jusque dans le monde entier 

3. Réveille en nous ce qui est tout endormi 
Ravivant la flamme du premier amour  
Reforme nos cœurs selon ta sainte Parole 
Pour que Rayonne l’Evangile du christ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'IL EST LE ROI',
      'contenu': '''
Il est le Roi (bis) 3X 
🎵Ténor :  Il est le Roi 
Tous :  Il est le Roi, Il est le Roi Jésus Christ seul est le Roi 
🎵Soprane : Il est le Roi (bis) 
Jésus est le Roi(bis) 4X 
Jésus Christ seul est le Roi ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'IL EST NE LE ROI DU MONDE ',
      'contenu': '''
1. Il est né le Roi du monde  
Le Christ le libérateur 
Que la terre au ciel réponde 
D’une voix, d’un même cœur. 

🎵Chœur : 
Dans l’étable misérable, 
Contemplez ce nouveau - né 
A la terre, O mystère ! 
Dieu lui-même s’est donné.

2. A tes pieds Roi sans couronne 
Jésus nous courbons nos fronts ; 
Ta crèche est pour nous un trône  
C’est là que nous t’adorons ! 

3. En notre âme vient renaître, 
O Christ elle a soif de toi ; 
Elle veut t’avoir pour Maître, 
Humble enfant glorieux Roi ! ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'IL EST TRES MERVEILLEUX ',
      'contenu':'''
Il est très merveilleux de s’associer pour Jésus  
Evangéliser le Faso, car il est grand temps 
Proclamer l’évangile et sauver les âmes perdues 
Oh, Alléluia Jésus revient bientôt 
OUI MES FRERES (🎵basse) 

🎵Refrain : 
C’est merveilleux, c’est vraiment bon,  
de donner  sa vie à Jésus pour la vie éternel 
C’est Jésus qui est la voie  
Qu’il est merveilleux d’appartenir à Christ 

Jésus donna sa vie sur la croix du calvaire 
Pour toi et moi il souffrit et fut mis à mort  
Mais au 3èmejour il ressuscita des morts 
Gloire à notre Dieu Jésus Christ est vivant.''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'IL EST UN SEUL CORPS',
      'contenu': '''
1/ Il est un seul corps, un seul Esprit, 
Un seul Esprit, un seul Esprit, 
Un chef suprême : c’est Jésus – Christ, 
Le seul Seigneur de l’Eglise. 
S’il a voulu tous nous baptiser, 
D’un même Esprit c’est pour nous sceller, 
En un seul corps qui doit révéler, 
Toute sa gloire promise

2/ Un seul baptême d’Esprit de feu, 
D’Esprit de feu, d’Esprit de feu, 
Anime son Eglise en tout lieu  
de la même ardente flamme, 
Avec amour mettant en commun, 
Ce que la grâce accorde à chacun, 
Par le salut nous ne sommes qu’un, 
En Christ un cœur et une âme. 

3/ Pour amener à maturité,  
Le corps entier dans l’unité, 
Le Christ de gloire vient le guider, 
Par l’apôtre et le prophète, 
Par l’Evangéliste-défricheur, 
Par le berger avec le docteur, 
Qui font des saints d’aptes bâtisseurs, 
De son Eglise parfaite. 

4/ Quand tout le corps est dans l’unité 
La charité, la sainteté, 
Le Seigneur vient s’y manifester, 
Dans sa splendeur et sa gloire : 
Des Saints le nombre est multiplié,  
Et les malades sont relevés, 
Le nom de Christ est magnifié, 
C’est le réveil, la victoire.''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'IL M’A DONNE SON FILS',
      'contenu': '''
Il m’a donné son fils Jésus (bis) 
Il fut battu, maltraité, cloué sur la croix où son sang coula 
Malgré toutes ses souffrances il m’a donné le salut (bis)  
Sans le payer''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'J’AI DONNE ',
      'contenu': '''
Réfrain : 
J’ai donné, il a donné 
Tu peux donner ta vie à Jésus Christ (bis) 

1/ Si aujourd’hui tu entends sa voix  
N’endurcis pas ton cœur ami 
Car il est le chemin, la vérité et la vie.

2/ Oh toi mon frère qui es tourmenté, 
Oh toi ma sœur qui est perdue 
Jésus est le chemin, la vérité et la vie''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'JE CHANTERAI ',
      'contenu': '''
Je chanterai de beaux et mélodieux chants  
Pour le Seigneur (bis) 
Je chanterai de jolis chants  
Jusqu’au jour de ma mort (bis) 
Je chanterai de beaux et mélodieux chants  
Pour le Seigneur''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'JE REMERCIE LE SEIGNEUR',
      'contenu': '''
Je remercie le Seigneur, le Seigneur  
Son amour n’a pas de fin  (bis)                     
Il m’a gardé, il m’a sauvé,  
Il m’a libéré de l’enfer 
C’est pourquoi je veux le louer 
Mon Seigneur est toujours vivant 
''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'JE SUIS CLOUE',
      'contenu': '''
1/ Je suis cloué sur la croix, je mérite bien mon châtiment 
Mais Sauveur oh quant à toi, tu es bien innocent 

Refrain :  
Sauveur rappelle-toi, Sauveur souviens-toi de moi 
Oh Oh Sauveur, rappelle-toi quand tu seras dans ton règne 

2/ Tout le monde t’a renié, mais quant à toi oh Jésus 
Tu es bien le fils aimé, le pain venu du ciel 

3/ Ami je te convie au grand festin quand le Sauveur reviendra 
Pour le monde ce sera la fin et nous verrons le grand Roi''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'JE TE RENDS GRACE',
      'contenu': '''
Je te rends grâce au Seigneur 
De m’avoir fait à ton image 
Pour cette grande bonté 
Je te donne ma vie  

    Seigneur tu m’as choisi, 
    Tu m’as choisi parmi mes frères 
    Tu m’as donné ton amour 
    Je te donne ma vie 

Seigneur je vis en toi 
En toi j’ai mis mon espérance 
En moi l’eau vive a jailli 
Je te donne ma vie 

    Seigneur, tu es ma joie, 
    Toi seul Seigneur es ma lumière 
    Je n’ai plus peur dans la nuit 
    Je te donne ma vie 

Je veux te glorifier 
Chanter ton Nom de par le monde  
Jusqu’à la fin de mes jours 
Je te donne ma vie''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'JE VEUX SERVIR',
      'contenu': '''
Seigneur Jésus (ter) 
Je veux servir Jésus mon maître mais 
Je n’ai pas de force ni de puissance 
Seigneur, viens me donner la puissance 
Et la force pour mieux te servir''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'JEHOVAH, CROIRE EN TOI C’EST LA VIE',
      'contenu': '''
Jéhovah(x2) croire en toi c’est la vie augmente nous la foi, Amen, Amen. 
Oh père oh puissant créateur, oh Jésus clément Sauveur, Esprit de 
lumière que nos cœurs soient ton sanctuaire, Alléluia, Alléluia. 

🎵Réfrain : 
🎶Bass: alleluia amen, amen, alleluia amen. Alleluia amen, amen, 
alleluia; alleluia, alleluia, alleluia, amen, amen, alleluia amen, amen. 
Soyons dans la joie, la joie, la joie des élus avec les anges ; Chantons un 
saint cantique à la gloire de Dieu, la gloire de Dieu, ô Roi des rois, ô Roi 
des rois, alléluia amen, amen, alléluia, amen, amen, amen, alléluia 
amen. 

🎶Ténor : 
alléluia amen, amen, alléluia amen, alléluia, alléluia, alléluia, 
alléluia, alléluia, alléluia, amen, amen, alléluia amen ;Soyons dans la 
joie, la joie, la joie des élus avec les anges ; Chantons un saint cantique à 
la gloire de Dieu, Chantons un saint cantique à la gloire de Dieu, alléluia 
amen, amen, alléluia amen, ô Roi des rois, ô Roi des rois, alléluia amen, 
amen, alléluia, amen, amen, amen, alléluia amen.

🎶Alto: 
alleluia amen, amen, alleluia amen. Alleluia amen, amen, alleluia; 
alleluia, alleluia, alleluia, amen, amen, alleluia amen, amen. Soyons 
dans la joie, la joie, la joie des élus avec les anges ; Chantons un saint 
cantique à la gloire de Dieu, la gloire de Dieu, ô Roi des rois, ô Roi des 
rois, alléluia amen, amen, alléluia, amen, amen, amen, alléluia amen. 

🎶Soprane :
alléluia amen, amen, alléluia amen, alléluia, alléluia, alléluia, 
alléluia, alléluia, alléluia, amen, amen, alléluia amen; Soyons dans la 
joie, la joie, la joie des élus avec les anges ; Chantons un saint cantique à 
la gloire de Dieu, Chantons un saint cantique à la gloire de Dieu, alléluia 
amen, amen, alléluia amen, ô Roi des rois, ô Roi des rois, alléluia amen, 
amen, alléluia, amen, amen, amen, alléluia amen.''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'JERUSALEM CITE DES CIEUX',
      'contenu': '''
1/ Jérusalem cité des cieux  
O glorieux séjour 
Viens, viens faire briller à nos yeux 
Tes jours de paix (bis) 
Tes jours de paix, d’amour 
Sainte cité d’Emmanuel 
Si douce à notre cœur  
Fais rayonner sur nous du ciel 
L’éclat de ta splendeur 
De cet Edem immaculé 
Le charme est sans rival  
Grand Dieu c’est là qu’est révélé  
L’amour vainqueur du mal 
J’ai soif de ton bonheur (bis) 
Jérusalem, Jérusalem ton nom remplit mon Cœur  
« Environné de sombres maux 
Luttant, souffrant encore » 

2/ Vers la cité du grand repos 
Mon cœur prend son essor 
Jérusalem séjour de paix tous mes désirs s’en vont 
S’en vont à toi bientôt  
Bientôt s’ouvriront tes palais 
Voici ton Roi (bis) 
Victorieux avec les siens 
A toi je viens Jérusalem  (bis) 
Cité Sainte des cieux 
Objet de tous mes vœux  
Amen''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'JERUSALEM, CITE DE DIEU ',
      'contenu': '''
1/Jérusalem, cité de Dieu, 
J’irai bientôt franchir ton seuil 
Et recevoir dans ton saint lieu, 
De mon Sauveur un doux accueil.

🎵Réfrain : 
Plus haut, plus loin plus loin que l’Assur infini 
Mes yeux verront verront mon rédempteur béni 
Dans son palais d’or pur d’or pur étincelant 
Où tout dit gloire gloire au grand Roi triomphant. 

2/ J’entends des chants harmonieux, 
Des harpes d’or au son si beau, 
Les rachetés dans les hauts cieux 
Entonnent l’hymne de l’Agneau. 

3/ Là je verrai tous mes trésors, 
Qu’ici-bas j’ai trop tôt perdus, 
Tous revêtus d’un nouveau corps, 
Nous louerons le Seigneur Jésus. 

4/Être avec Christ, ô saint espoir ! 
Le contempler dans sa bonté, et 
Sur son trône oser m’asseoir 
Avec lui pour l’éternité.''',
    });

    

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'JESUS A TOI LA GLOIRE  ',
      'contenu': ''' 
      Jésus à toi la gloire, à toi la gloire (3fois) 
A toi la gloire (bis) 
Jésus de Nazareth à toi la gloire 
Jésus de Nazareth 
Joie, Joie, Joie, avec Joie, nous te louons (bis) 
Car tu nous as apporté notre précieux salut 
C’est pourquoi (nous te louons) bis 
Jésus de Nazareth ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'JESUS EST MORT ',
      'contenu': ''' 
       🎵Solo : 
       Jésus est mort, 
       il est mort, 
       il est mort 

🎵Tous 
Sur la croix (ter) 
Pour nous racheter
      🎵Solo 
      Glory Alléluia, 
      Alléluia, Alléluia 

🎵Tous
Il s’est levé (ter) 
Pour nous racheter ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'JESUS EST NE',
      'contenu': '''
1. Jésus est né ! venez bergers et mages, 
Anges du ciel portez-lui vos hommages, 
Oui gloire aux cieux,) 
Paix en tout lieu) bis 

2. Voilà l’enfant qui doit Sauver le monde, 
Quel doux éclat et quelle paix profonde 
Rayonne autour) 
Du Dieu d’amour) bis 

3. Il a voulu pour notre délivrance 
Naître ignoré, pauvre et sans apparence ; 
Humble aussi) 
Allons à lui) bis 

4. Tout ce qui plait à ce Roi débonnaire 
C’est un cœur pur, formé par la prière 
A toi ce cœur) 
O bon sauveur) bis 

5. A toi ce cœur et qui te glorifie 
Non pour un jour, mais pour toute la vie  
Il est à toi) 
Sois-en le Roi) bis ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'JESUS MON ABRIS SUR ',
      'contenu': '''
1/  En Jésus Christ mon abris sûr, je suis régénéré 
Une nouvelle créature, un homme sans passé 
Tout est nouveau, Tout est nouveau en lui Tout est nouveau 
Sa propre Divine nature en moi ne peut pécher  

2/ De mon vieil et de mon moi, Jésus m’a délivré, 
En lui je suis mort à la croix avec tout mon péché 
Crucifié, crucifié en lui crucifié 
Par le baptême alléluia oui mort et enterré 

3/ Quand le malin veut me tenter, il ne me trouve plus 
En Jésus Christ je suis caché que me faut-il de plus 
Caché en Christ (bis) en lui j’ai disparu,  
le monde a perdu tout attrait, je ne veux que Jésus 

4/ Ressuscité en Jésus Christ et baptisé de feu 
Assis sur son trône avec lui dans les célestes lieux 
Tout m’est donné (bis) en Lui tout m’est donné 
Par le baptême de l’Esprit en Christ tout m’est donné 

5/ Mais plus encore sur la croix pour moi tu t’es donné, 
Mon cœur ému t’adore et croit comment ne pas t’aimer 
Ton grand amour (bis) oh Christ m’a désarmé, mon cœur 
mon âme sont à Toi, à Toi seul désormais. ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'JESUS SON RETOUR',
      'contenu': '''
1/ Bientôt va s’ouvrir le ciel et Jésus reviendra 
Dans sa gloire et pour toujours Il nous enlèvera 
Là sera récompensé quiconque aura bâti 
Avec de l’argent, de l’or aux ordres de l’Esprit

🎵Refrain 
Le ciel va s’ouvrir oh alléluia 
Et dans sa gloire Jésus viendra 
Finis les larmes et les combats  
Dans tous les siècles il règnera 

2/Vois les signes de la fin tout Israël fleurit 
Dieu répand sur toute chair en tout lieu son Esprit 
Il rassemble en un seul corps et unit dans l’amour  
Tous ses enfants dispersés ce sont les derniers jours 

3/Es –tu prêt pour ce grand jour ? Es –tu vraiment sauvé ? 
Le cœur détaché du monde et libre du péché 
Aimes-tu ton maître d’un inaltérable amour 
Hâtant de tes vœux et tes prières son retour''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'JEUNES CHRETIENS SENTINELLES ',
      'contenu': '''
Jeunes chrétiens Sentinelles Débout/ 
Levez-vous, levez-vous 
Car la fin est proche et Satan fait rage/ 
En avant combattez 
Là-haut dans les cieux/ 
La cité de Dieu / 
Finiront nos cris et 
tous nos malheurs  
Le Seigneur Jésus effacera/ 
toutes nos larmes de nos yeux''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'JOIE ALLELUIA ',
      'contenu': '''
Joie alléluia joie Ossiana joie 
Au jour du Seigneur alléluia   
Joie alléluia joie Ossiana joie 
Au jour du Seigneur alléluia   
Joie alléluia joie Ossiana joie 
Au jour du Seigneur 

Sinongo alléluia sinongo ossiana sinongo 
Zusoaba waongo daare (bis)''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': '''L'AFRIQUE SERA SAUVEE''',
      'contenu': '''
1/ Si vous croyez et que je crois 
Et qu’ensemble nous prions 
Nous verrons descendre l’Esprit 
Et l’Afrique sera sauvée

🎵Refrain 
Et l’Afrique sera sauvée (BIS) 
Oui le Saint – Esprit descendra  
Et l'Afrique sera sauvée 

2/ Dieu qui nous aime nous donna  
Le salut par Jésus 
Acceptons Christ de tous nos cœurs 
Et l’Afrique sera sauvée 

3/ Jésus qui m’aime t’aime aussi 
N’en doute pas mon frère 
Accepte-le rends témoignage 
Et l’Afrique sera sauvée''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': '''L'AMOUR DE DIEU''',
      'contenu': '''
L’amour de Dieu de loin surpasse 
Ce qu’en peut dire un cœur humain. 
Il est plus grand que les espaces, 
Même en l’abîme il nous atteint. 
Pour le péché de notre monde, 
Dieu nous donna Jésus. 
Il nous pardonne, O paix profonde, 
Il sauve les perdus. 

🎵Refrain : 
L’amour de Dieu si fort, si tendre  
Est un amour sans fin : 
Tel est le chant que font entendre  
Les anges et les saints.

Versez de l’encre dans les ondes, 
Changez le ciel en parchemin, 
Tendez la plume à tout le monde 
Et chacun soit écrivain : 
Vous dire tout l’amour du père 
Ferait tarir les eaux 
Et remplirait la place entière 
Sur ces divins rouleaux. 

Et que le monde un jour chancelle 
Avec ses trônes et ses rois, 
Quand trembleront tous les rebelles, 
Soudain saisis d’un grand effroi. 
De Dieu l’amour que rien ne lasse 
Pour nous encore vivra : 
C’est le miracle de la grâce 
Amen ! Alléluia !''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': '''L'AMOUR DU SEIGNEUR ''',
      'contenu': '''L’amour du Seigneur est un amour incomparable 
Oh quel merveilleux amour que celui du Seigneur Jésus ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': '''L'AN NOUVEAU VIENT DE COMMENCER ''',
      'contenu': '''
🎵Refrain : 
L’AN NOUVEAU VIENT DE COMMENCER 
UN AN DE GRACE ET DE DELIVRANCE 
L’AN NOUVEAU VIENT DE COMMENCER 
LOUONS DIEU QUI NOUS L’A DONNE

LA VICTOIRE ET LA SAINTETE 
TOUT CE QUE NOTRE CŒUR DESIR 
LA VICTOIRE ET LA SAINTETE 
EN JESUS TOUT NOUS EST DONNE 

CHRIST CONDUIT L’EGLISE EN AVANT 
CAR IL TIENT TOUTES SES PROMESSES 
CHRIST CONDUIT L’EGLISE EN AVANT 
ACCOMPLIT SES GLORIEUX PLANS 

TOUT PROCHE EST L’ACCOMPLISSEMENT 
DU CONSEIL DE DIEU POUR L’EGLISE 
TOUT PROCHE EST L’ACCOMPLISSEMENT 
CHRIST REVIENT C’EST L’ENLEVEMENT''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'LA HAUT LES ELUS DE DIEU CHANTAIENT  ',
      'contenu': '''
Là-haut les élus de Dieu chantaient l’agneau 
Ils acclamaient Jésus – Christ le Roi des Rois 
Qui triompha de l’ennemi par la croix 
Nous introduisant dans un monde nouveau

Acclamons l’Agneau 
Le grand vainqueur de golgotha 
Acclamons l’Agneau 
Et disons gloire Alléluia 

Ce merveilleux chant d’amour des bienheureux 
Nous le chanterons durant l’éternité 
En l’honneur du grand sauveur dans la bonté 
Pour nous ouvrir le beau royaume des cieux  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'LA NOËL EST UN JOUR BENI',
      'contenu': '''
La noël est un jour béni pour nous (bis) 
Car notre Sauveur est né le jour de noël (bis) 
Louons Jésus Christ, élevons son, car Il est notre Roi 
Rendons gloire à Dieu pour l’éternité  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'LE BON COMBAT ',
      'contenu': '''
Bass :  J’ai combattu le bon combat, combat 
Tous :  J’ai achevé la course, j’ai gardé la foi 
Désormais la couronne de vie m’attend 
J’ai combattu le bon combat, 
Soprane : J’ai fait le bon combat, 
Tous : Désormais la couronne de vie m’attend 
J’ai combattu le bon combat  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'LE JOUR OU JE SERAI DANS LE ROYAUME',
      'contenu': '''
Le jour où je serai dans le royaume de Dieu 
Je louerai l’Eternel, devant des milliers, des milliers 
Et des milliers d’anges je chanterai Alléluia 

🎵1ère voix :Je chanterai, je louerai le nom de l’Eternel  
Ça me sera une grande joie immense ce jour là 
Quand je serai au paradis. 

🎵Ténor:Louez l’Eternel avec respect et joie 

Tous :Elevons son nom 

🎵1èrevoix :Louez-le, louez-le 
Louons l’Eternel 
Louez-le,louez-le 
Elevons son Saint nom 

Célébrons-le ,Exaltons-le 
Tous les habitants de la terre célébrons Dieu 
 ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'LE MAITRE NOUS ENTRAINE ',
      'contenu': '''
1/  Amis venez le maître nous entraine  
Ouvrons nos cœurs ouvrons à son Esprit 
Qui plein de feu nous libère de toute peur  
Et les plus dures des chaines sont bannies 

🎵Refrain :
Alors élevons la bannière 
De notre roi victorieux 
Tenons bien ferme, oui notre père 
Il nous unit au fils de Dieu 
Quand il fait beau, chantez la gloire,  
de notre Roi victorieux 
A lui la gloire et la victoire 
Et c’est la joie à notre Dieu 

2/ Pour être fort vivons dans la prière 
Avec le Christ on peut braver l’enfer 
Il est l’ami pour nous et plus qu’un frère  
Il fait fleurir les terres du désert 

3/ Tout bon soldat revêt de Dieu l’armure 
Et sans broncher et charger de sa croix 
Il combat fort avec sagesse et vaillamment  
Un jour là-haut, il sera couronné.  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'LE MARIAGE  ',
      'contenu': '''  
Soprano : Le mariage  (3 fois) 
Bass :Institué par, institué par, institué par Dieu 
Tous : Dans le jardin d’Eden entre Adam et Eve 

Soprano :Tout Homme doit unir
Tous :Comme Adam et Eve 

Soprano :L’homme doit  
Tous :L’homme doit quitter ses parents 

Soprano : Pour s’unir  
Tous : Pour s’unir avec sa femme
Soprano : Et former 

Tous :  Et former une seule chair  
comme l’Eternel l’a voulu 
Que le Seigneur vous bénisse et vous protège (bis) 
Qu’il vous regarde avec bonté 
Et qu’il vous donne sa paix 
Que le Seigneur vous manifeste sa bienveillance  
''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'LE SIGNAL DE LA VICTOIRE  ',
      'contenu': '''
Le signal de la victoire 
Déjà brille aux cieux. 
La couronne de la gloire 
Paraît à nos yeux.

🎵Refrain : 
Je viens, combattez encore ! 
Dit Jésus à tous, 
Oui, mon Sauveur, je t’implore, 
Je lutte à genoux. 

Que l’ennemi plein de rage, 
Redouble ses coups  
Nous ne perdons point courage  
Christ est avec nous.

Suivons, amie, la bannière, 
Du Sauveur en croix, 
Et que notre armée entière  
Se range à sa voix. 

Rude et longue est la mêlée ; 
Voici le secours ! 
Dans nos mains prenons l’épée 
Qui vainquit toujours !''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'LORSQU’ON  AMENAIT LE SEIGNEUR  JESUS ',
      'contenu': '''
Lorsqu’on amenait le Seigneur Jésus  
A Golgotha, Des femmes le suivaient 
Elles le pleuraient se lamentaient 
Jésus leur a dit pleurez sur vous 

Ne pleurez pas sur moi 
Ne pleurez pas sur moi 
Habitants de la terre, pleurez sur vous 

Esi okplo Yesu yina 
Le golgotha mela okpledo 
Oléa vifan o fan kogne 
Yesu blombe mifa mian tôlo 

Migafan namlo, migafan namlo 
Agbe nolao mifa-mian tôlo ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'LOUONS LE SEIGNEUR DIEU ',
      'contenu': '''Louons le Seigneur Dieu et chantons gloire 
Louons le Seigneur Dieu pour son amour (bis)  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'LOUONS TOUS DIEU  ',
      'contenu': '''Louons tous Dieu, dans son sanctuaire                                 
Louons – le pour sa grandeur et bonté                           
Louons – le au son de toutes trompettes                                  
Louons – le avec des tambours et danses               
Avec des instruments à cordes  
Avec des cymbales sonores et le chalumeau 
La harpe et le lutte 
Que tous ce qui vit loue l’Eternel Dieu''',
    });

    await db.insert('chants', {
      'langue': 'Moore et Autres',
      'titre': 'MAM ZUSOB KANSENGA ',
      'contenu': '''1. Mam yân laafi kansenga mam sê da ka mi 
Ne sunoogo duniâ ka toê kon ; 
Wakat mam sê kôn menga la’m suri zânga 
Mam zusoba Dima kansenga 

🎵Refrain: 
Mam zusob Jésus Dima kansenga 
Malekramba waogda yâmba daar bud fân 
Mam yigimdida yâmb taore Jésus 
Mam zusoba Dima kansenga 

2. Mam nong ti yâmb taï mam daar fân ne yâmb siiga 
Ti mam nan sake yâmb wakat fân; 
Ne yâmb menga pânga, mam tinbo pasa me 
Mam zusoba Dima kansenga 

3. Bum fân mam sâ pam mam basa Jésus nugê 
Yâm sakere na yi mam yôndo 
Mam zaka, bum fân sê bebe ya yâmb n so 
Mam zusoba Dima kansenga 

4. MBa songo yâmb pê mam yiid’m zoaramba fân 
Pâng soba, vim kônta bi taï mam; 
Pêgre, naam la waogre la pânga, yâmb n so 
Mam zusoba Dima kansenga  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'MARIAGE ',
      'contenu': '''
Alléluia je te verrai face à face 
Le frère……. Qui m’a tant aimé 
Alléluia je te verrai face à face  
au grand jour du Seigneur  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'MARIAGE  ',
      'contenu': '''
Voici la sœur …… qui marche vers son conjoint 
Unis d’un même lien d’amour béni soit le Seigneur 
Que le frère… a choisit pour l’honneur de notre Dieu 
Ils sont unis d’un lien même lien d’amour béni soit le Seigneur   ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'MARIAGE ',
      'contenu': '''On l’appellera merveilleux (3X) 
Merveilleux, merveilleux  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'MATELOT ',
      'contenu': '''
1/Matelot en voyage vers le bord éternel  
S’il survient un orage pensons aux doux rivages   (bis)

Réfrain : 
Notre port (bis) est au ciel 
Notre port (bis) est au ciel 
Notre port est au ciel

2/ Que rien ne nous dérive  
Vers les biens temporels 
Leur paix est fugitive 
Ne cherchons qu’une rive  

3/ Sur Jésus douce étoile  
D’un éclat immortel 
que jamais rien ne voile 
Dirigeons notre voile   

4/ A celui qu’il seconde 
D’un regard fraternel 
Que fait le vent ou l’onde ? 
En vain l’océan gronde   

Refrain : 
Quand le port (bis) est au ciel 
Quand le port (bis) est au ciel 
Quand le port est au ciel (bis)   ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'MERCI A TOI MON DIEU ',
      'contenu': '''Merci à toi mon DIEU (Merci à toi) 
A cause de ta grandeur. 
J’ai trouvé cette victoire en toi 
Merci à toi, mon DIEU bis                     
Merci beaucoup 

🎵Soprano/Alto 
O Jésus, tu as écouté ma voix ; 
Tu m’as fait marcher  
Conduit par l’Esprit Saint ;  bis 
Reçois mon merci, merci à toi, 
Mon Dieu merci beaucoup. 

🎵Basse/Tenor
J’ai trouvé la joie   (3X)     
Par ton Esprit Saint 
J’ai trouvé la joie, merci à toi, 
Merci ! mon Dieu merci beaucoup.

🎵Basse  Merci beaucoup. 

🎵Tenor/Soprano/Alto   Mon Dieu merci beaucoup  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'MERVEILLEUX AMOUR DE JESUS ',
      'contenu': '''
1/ Merveilleux amour de Jésus 
Merveilleux éternel salut 
Merveilleux dont tu m’as élu  
Gloire à ton saint nom. 

🎵Refarin 
Merveilleux, Merveilleux Jésus 
Merveilleux, Merveilleux Jésus 
Tu es un merveilleux Sauveur 
Gloire à ton saint nom. 

2/ Merveilleuse est ta tendre main 
Merveilleux sont tous tes chemins 
Merveilleux guide ami divin  
Gloire à ton saint nom. 

3/ Merveilleuse est ta voix Seigneur 
Merveilleux dessein de mon cœur 
Merveilleux chef puissant vainqueur 
Gloire à ton saint nom.  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'MIRACLE DE DIEU  ',
      'contenu': '''
Miracle de Dieu adorons-le (bis) 
Il est si grand, si grand, si large, mes frères, mes sœurs venez à 
lui vous réussirez (bis)  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'MON SEUL APPUI C’EST L’AMI CELESTE ',
      'contenu': '''
Mon seul appui c’est l’ami céleste 
Jésus seul, Jésus seul 
Les ans s’en vont cet ami me reste 
Jésus seul, Jésus seul 

Refrain : 
Cet ami connaît mes alarmes 
Son amour guérit ma douleur 
Sa main essuie toutes mes larmes 
Doux Sauveur doux Sauveur 

Tout mon désir c’est de le connaître 
Jésus seul, Jésus seul 
Et que sa paix remplisse mon être 
Jésus seul, Jésus seul 

Je le suivrai cet ami me guide 
Jésus seul, Jésus seul 
A travers ce grand désert aride 
Jésus seul, Jésus seul 

Dans le danger toujours il me garde 
Jésus seul, Jésus seul 
Dans mes soucis, à lui je regarde, 
Jésus seul, Jésus seul 

Merci Seigneur de ce don suprême 
Jésus seul, Jésus seul 
Il m’appartient je le sais je l’aime 
Jésus seul, Jésus seul  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'NOEL UN JOUR BENI  ',
      'contenu': '''La Noël est un jour béni pour nous (bis) 
Car notre Sauveur est né le jour de noël 
Louons Jésus Christ élevons son nom 
Car il est notre Roi, rendons gloire à Dieu pour l’éternité   ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'NOËL, NOËL DIEU EST VENU CHEZ NOUS ',
      'contenu': '''
🎵Refrain : 
Noel, noël Dieu est venu chez nous  
Oui Dieu reste avec nous (2X) 

🎵Soprane : Noel, noël 

🎵Ensemble : O quelle grande joie d’avoir ainsi beau Roi. 

1. Le mystère annoncé, aujourd’hui s’accomplit 
2. Le verbe s’est fait chair, pour arriver chez nous 
3. Gloire à Dieu dans les cieux, paix aux Hommes sur la terre 
4. Bénissez le Seigneur, magnifions sa puissance 
5. O quelle grande joie, d’être ami d’un grand Roi 
6. Il est grand notre Dieu, lui seul fait des merveilles 
  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'NON NOUS NE SAURIONS NOUS TAIRE ',
      'contenu': '''1/ Non nous saurions nous taire 
Devant tant de cœurs souffrants 
Resterez-vous sans rien faire ? 
Seriez-vous indifférents ? 

🎵Refrain 
Sous la croix rien n’est pénible, 
En avant frère, débout ! 
Par la foi tout est possible, 
Et la couronne est au bout. 

2/ En tout lieu, plein d’espérance, 
Traçons un sillon d’amour, 
Semons avec confiance ; 
Nous moissonnerons un jour.

3/ Au monde sans repentance 
Prêchons Jésus mort pour tous, 
Pourquoi tant d’insouciances ? 
Il en est temps levons-nous  

4/ Laissons là notre paresse,  
Et l’amour triomphera ; 
Oui malgré notre faiblesse, 
La vérité prévaudra  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'NOUS MARCHONS DANS LA LUMIERE ',
      'contenu': '''Nous marchons dans la lumière de Dieu (bis) 
Nous marchons, marchons, nous marchons Oh o, o, o ! 
Nous marchons dans la lumière de Dieu 

We are walking in the light of god  
light of god 
We are walking, walking, walking oh o, o, o 
We are walking in the light of god  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'NOUS SOMMES HEUREUX PEUPLE ',
      'contenu': '''Nous sommes heureux peuple louons Dieu 
Nous avons la bible parole de Dieu 
Satan nous a attaché 
Jésus nous a délivré sur la croix 
Du calcaire oh louons Dieu  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'NOUS TE CELEBRONS ',
      'contenu': '''Nous te célébrons prends pitié de nous 
Tes enfants te prient à genoux 
Ecoute nos cris garde-nous du mal 
Délivre-nous de tout péché 
  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'NOUS VOULONS QUE JESUS SOIT NOTRE ROI ',
      'contenu': '''I. 
Nous voulons que Jésus soit notre Roi (bis) 
🎵Ténors :    Louons–le  
Ensemble :  Louons le Roi des rois ; Que son Nom soit loué 
II. 
Nous Voulons que la paix soit dans nos cœurs (bis) 
🎵Ténors : La paix de Dieu 
Ensemble : La paix que Jésus donne ; Est pour l’éternité !  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'NUL N’EST COMME MON SAUVEUR ',
      'contenu': '''1. Nul n’est comme mon Sauveur aucun ami comme lui 
Il est toujours ma lumière quand sur terre il fait sombre 
Quand éclosent les fleurs d’été il est ma joie suprême  
Oh que mon cœur et ma vie soient à son seul service

🎵Refrain : 
Nul, nul n’est comme mon précieux Sauveur  
Aucun ami ne peut l’égaler 
Gloire à Jésus, il prend soin de moi 

2. Nul n’est comme mon Sauveur, en des temps de détresse 
Il m’attire tout prêt de lui, me console me bénit ;   
Quand survient la tentation son bras droit me soutient 
Ses anges campent autour de moi me préservent de tout mal 

3. Nul n’est comme mon Sauveur, il pardonne mes péchés 
Il me donne son Saint Esprit une source d’eau vive en moi  
Il conduit au service mon maître tendre et doux 
Oh ! Merveilles de toutes merveilles, oui je suis son enfant 

4. Nul n’est comme mon Sauveur, reçois cette vérité ! 
Il se donna en rançon versa son sang pour moi,  
Arrivé à la cité de lumière éternelle, 
Nous chanterons avec les anges honneur puissance et force  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'O DIEU PUISSANT ',
      'contenu': '''O Dieu puissant, digne d’être admiré 
Est l’univers que ta main a formé 
Tu l’as fondé par ton pouvoir,  
Tu l’as fondé par ton pouvoir,  
Tu l’as fonde par ton pouvoir,  
Le monde est plein, est plein de ta gloire, 
Le monde est plein est plein de ta gloire, 
Je veux louer mon Dieu tant que je vivrai, 
Je veux louer mon Dieu tant que je vivrai 

Refrain :
Seigneur mon Dieu que tes œuvres sont belles ! 
Seigneur mon Dieu que tes ouvres sont belles ! 

Bass : elles sont belles O Eternel ! 
Ensembles : tu les as faites, 
Bass : Tu les as faites avec sagesse 
Ensemble : Avec sagesse  
Je te magnifierai tant que je vivrai (2X)''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'O NOTRE DIEU TU FAIS BRILLER  ',
      'contenu': '''
1/ O notre Dieu tu fais briller ta face  
Sur ces époux qui, la main dans la main 
Viennent chercher les trésors de ta grâce 
Avant de se mettre ensemble en chemin. 

🎵Refrain 
O Dieu d’amour, du flot pur et limpide 
De ton amour tu remplis ce foyer, 
Afin qu’il soit sur cette terre aride 
Une oasis de paix de sainteté (bis) 

2/ Toi seul rendras heureux leur mariage, 
Ils se confient l’un et l’autre en toi, 
En acceptant dans leur commun voyage 
Tout ce que veut ta bonne et sainte loi. 

3/ Il n’est de bien que ceux que tu nous donnes, 
Et le seul vrai bonheur nous vient d’en haut ; 
Les fronts sont clairs quand c’est toi qui couronnes, 
Tu rends léger les plus pesant fardeaux. 

4/ Ils marcheront, Seigneur, à ta lumière, 
Tu renouvelleras en eux l’ amour ; 
Tu sauras exaucer chaque prière,  
Les guider par la main jour après jour.  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'O VOUS QUI N’AVEZ PAS LA PAIX  ',
      'contenu': '''
1/ O vous qui n’avez pas la paix venez, Jésus la donne. 
Pure, profonde et pour jamais, venez, Jésus pardonne. 
Quand Jésus remplit un cœur, il déborde de bonheur  
Et l’effroi ne l’atteint plus, gloire ! Gloire à Jésus !

2/ Vous qui tombez à chaque pas, venez, Jésus délivre. 
Celui qui se jette en ses bras peut à toujours le suivre. 
Quand Jésus remplit un cœur, il déborde de bonheur ! 
Car il ne chancelle plus, gloire ! Gloire à Jésus ! 

3/ Vous qui tremblez sur la terreur,  
Que la mort vous inspire, 
Venez, votre libérateur a détruit son empire. 
Avec Lui, nous revivrons, avec Lui, nous régnerons, 
Et la mort ne sera plus : gloire ! gloire à Jésus !  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'OH DIEU DE PUISSANCE ! ',
      'contenu': '''1. O Dieu de puissance ! Viens en ce beau jour 
Bénis l’alliance, faite en ta présence : 
Que ses deux époux ici  
Cherchent en toi leur sûr appui ;  
Viens les remplir dès aujourd’hui ;  
de ton Saint amour 

2. Toi l’ami fidèle, Jésus bon Sauveur ! 
Que ton amour scelle, leur foi mutuelle ; 
Fais que joyeux désormais, unis en toi seul pour jamais, 
Ils trouvent dans ta douce paix, l’éternel bonheur ! 

3. Toi qui sanctifies, Saint Esprit de Dieu 
Consacre ces vies, par toi-même unies, 
Et, qu’au Dieu qui les bénit,  
Qui les Sauve et qui les conduit, 
Au père, fils et Saint - Esprit,  
Soit gloire en tout lieu !  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'OH DIEU NOUS SOMME LA POUR BTE LOUER ',
      'contenu': '''(Solo) Oh Dieu nous sommes là pour te louer 
Tous : Oui nous sommes là (02), nous sommes là pour te louer 
(Solo) Oh Dieu nous sommes là pour t’invoquer 
Tous : Oui nous sommes là (02), nous sommes là pour te louer 
(Solo) Jésus nous sommes là pour t’adorer 
Tous :Oui nous sommes là (02), nous sommes là pour te louer 
(Solo) Lagos nazaï walagnon 
Tous : Yè nazaï (2) Lagos nazaï ataïboto 
(Solo) Lagos nazaï walagnon é 
Tous :Yè nazaï (2) Lagos nazaï ataïboto 
(Solo) Comment ne pourrais-je pas te louer oh Yahvé 
Tous : Pour la vie que tu nous donnes, Oui nous sommes là (02), nous 
sommes là pour te louer 
(Solo) Comment ne pourrais-je pas te louer oh Yahvé 
Tous : Pour la paix que tu nous donnes, Oui nous sommes là (02), nous 
sommes là pour te louer 
(Solo)Comment ne pourrais-je pas te louer oh Yahvé 
Tous :Pour la joie que tu nous donnes, Oui nous sommes là (02), nous 
sommes là pour te louer''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'OH DONNEZ-MOI JESUS ',
      'contenu': '''1/ Oh donnez-moi Jésus, le Sauveur des perdus 
L’ami tant désiré, de mon cœur altéré : 
Il n’est point de bonheur sans ce divin sauveur,  
Aussi, je ne veux plus que le nom de Jésus. 

🎵Refrain 
Nom si beau si pur, nom si merveilleux 
Son éclat remplit les cieux, 
J’ai trouvé le bonheur j’ai trouvé le salut  
Par le seul nom de Jésus. 

2/ Qu’est tout l’or et l’argent, qu’est le plus beau présent 
Que sont tous les honneurs sinon des biens trompeurs 
Dans l’immense univers rien ne m’est aussi cher,  
Rien n’apaise mon cœur que Jésus mon Sauveur 

3/ Le plus beau lys des champs n’est pas si ravissant 
Du miel de sa douceur, il passe la saveur ! 
Tel est mon bien aimé qui pour moi s’est donné 
Je ne puis un seul jour vivre sans son amour ! 

4/ Le discours du prochain, les assauts du malin 
Ne sauraient m’ébranler, Christ est mon bouclier 
Il est mon chef mon Roi et je puis par la foi 
Du monde et de l’erreur être plus que vainqueur 
  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'OH NOM DIVIN NOM REDEMPTEUR  ',
      'contenu': '''1/ Oh nom Divin nom rédempteur, 
Jésus puissant Sauveur 
Jésus puissant Sauveur ! 
Nous prosternant tous devant toi,

🎵Refrain 
Nous te couronnons,  
Nous te couronnons  
C’est toi Jésus, 
C’est toi que nous couronnons 
Roi 

2/ Avec les anges dans les cieux. 
Les martyrs glorieux. 
Les martyrs glorieux. 
Qui jadis ont souffert pour toi,

3/ Racheté au prix de ton sang. 
O Sauveur tout-puissant, 
O Sauveur tout-puissant, 
Sauvé par grâce et par la foi, 

4/ C’est toi le vrai roi d’Israël  
Jésus Emmanuel,  
Jésus Emmanuel,  
Tu gouverneras par la loi, 

5/ Bientôt nous te verrons au ciel 
Sur ton trône éternel 
Sur ton trône éternel 
Mais ne vivant déjà qu’en toi,  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'OH OUI ',
      'contenu': '''OH oui j’accepterai tout ce qui arrivera dans ma vie, je suis prêt 
Le temps de Dieu est meilleur, je me confie en l’Eternel 
OH oui j’accepterai tout ce qui arrivera dans ma vie, je suis prêt 
  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'OH ! CONSOLEZ MON PEUPLE ',
      'contenu': '''1/ Oh ! Consolez mon peuple que j’aime, 
Oh ! Consolez, oui Consolez ! 
Parlez au cœur de Jérusalem : 
Sa servitude est finie. 
Voici tous ces forfaits expiés, 
Car l’Eternel lui-même a payé, 
Double rançon pour tous ses péchés, 
En Jésus Christ le messie ! 

2/ Le peuple est comme l’herbe des champs, 
Se desséchant quand vient le vent 
Seule subsiste éternellement de notre Dieu la parole. 
Dans le désert frayez son chemin, 
Aplanissez crêtes et ravins : 
Dans sa puissance le Seigneur vint, 
Comme un berger Il console 

3/ Qui a créé l’océan sans fin ? 
Qui donc le tient au creux des mains ? 
Et qui conseille l’esprit divin, 
Pour lui montrer la sagesse ? 
Pourquoi dis-tu peuple d’Israël : 
« Mon droit échappe à l’œil éternel » ? 
Ton Dieu tiendra son pacte immortel, 
Jamais il ne te délaisse. 

4/ Il est le Dieu de l’Eternité  
Il a créé le monde entier 
Et guide au but avec majesté, 
La grande histoire des siècles. 
Non, sa vigueur jamais ne fléchit, 
Il fortifie les affaiblis, 
Celui qui compte sur son appui, 
Prendra son vol comme l’aigle. 

5/ Jacob que j’aime ne crains donc pas : 
Il vient à toi, Jésus ton Roi, 
Pour établir la paix et le droit, 
Et te donner la victoire. 
Ne craignez plus, mais levez les yeux, 
Vers le chef- d’œuvre de notre Dieu : 
Nouvelle terre, oui nouveaux cieux, 
Tout est rempli de sa gloire !  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'OH ! QUEL BONHEUR DE LE CONNAITRE ',
      'contenu': '''1. Oh ! quel bonheur de le connaître, L’ami qui ne saurait changer, 
De l’avoir ici-bas, Pour défenseur et pour berger ! 
Réfrain :  
🎵Soprano : 
Chantons, chantons d’un cœur joyeux, 
Le grand amour du rédempteur, 
Qui vint à nous du haut des cieux, 
Et nous sauva du destructeur 

🎵Alto : 
Chantons, chantons d’un cœur joyeux, 
Le grand amour du rédempteur, du rédempteur, 
Qui vint à nous du haut des cieux, 
Et nous sauva du destructeur !du destructeur  

🎵Ténor : 
Chantons, chantons d’un cœur joyeux, (bis) 
Le grand amour du rédempteur, 
Qui vint à nous du haut des cieux,(bis) 
Et nous sauva du destructeur,(bis)

🎵Basse : 
Chantons, chantons d’un cœur joyeux, (bis) 
Le grand amour du rédempteur, (bis) 
Qui vint à nous du haut des cieux, (bis) 
Et nous sauva du destructeur, du destructeur

2. Dans la misère et l’ignorance, Nous, nous débattions sans espoir, 
La mort au cœur l’âme en souffrance, Quant à nos yeux il se fit voir. 

3. Il nous apportera la lumière, la victoire et la liberté ; 
L’ennemi mordit la poussière, Pour toujours Satan fut dompté. 

4. Vers l’avenir marchons sans crainte et sans souci du lendemain, 
Pas à pas ; nos pieds dans l’empreinte, De ses pieds sur notre chemin.  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'OU TROUVER UNE RETAITE ',
      'contenu': '''1/ Où trouver une retraite 
Où trouver un sur abris 
Quand du sein de la tempête 
Dieu me parle au Sinaï ? 

🎵Refrain                                               
Vois la mort que j’ai soufferte 
Pour devenir ton Sauveur ! 
Entre par la plaie ouverte, 
Et cache-toi dans mon cœur! 

2/ Quelle cité de refuge       
S’offre pour l’homme perdu    
Quand fuyant devant son juge   
Il tremble et pleure et perdu    

🎵Refrain  
Vers moi sans repos ni trêve 
Accours c’est ton seul espoir 
Mon cœur qu’a percé le glaive 
S’ouvre pour te recevoir 

3/Quand il faudra rendre compte 
Au Dieu qui t’affrontera ? 
Où cacherai-je ma honte, 
Quand ton œil me sondera ? 

🎵Refrain 
Si tu veux fuir ma colère 
Cache-toi dans mon amour 
Approche-toi du calvaire Et ne 
crains plus le grand jour 

4/Mais mes fautes plus nombreuses 
Que le sable au bord des mers, 
Rendent mes nuits trop affreuses   
Et mes regrets trop amers ! 

Refrain 
Pauvre âme, sois rassurée 
Mon sang, à flots épanché 
Couvre comme une marée 

5/ A son banquet misérable 
Le monde m’appelle en vain 
Oh ! Fais-moi place à ta table 
Et donne-moi de ton pain ! 
Le sable de ton péché. 
Prends je suis le pain de vie 
Prends ta place à ce festin 
Où Dieu même te convie 
Et qui n’aura point de fin  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'OUVREZ-VOUS PORTES DU TOMBEAU ',
      'contenu': '''1/  Ouvrez – vous portes du tombeau ! 
Jésus parait ! Oh qu’il est beau ! 
Il revit, o merveilles !  
Le péché, l’enfer et la mort 
En vain, ont uni leurs efforts ! 
Mon rédempteur s’éveille ! 

🎵Refrain 
Il vit ! Je sais qu’il vit ! (bis) 
Je sais que mon Rédempteur vit  

2/ Voyez ses mains, ses pieds percés 
Et les stigmates qu’ont laissés 
Le fouet, le fer, l’épine ; 
C’est pour moi qu’Il a tant souffert, 
Il m’a délivré de l’enfer, 
O charité divine ! 

3/ Je n’ai plus rien à redouter 
De mon Sauveur puis-je douter ? 
Sa promesse est formelle, 
Au tombeau mon corps descendra 
Mais Christ le ressuscitera 
Pour la vie éternelle !  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'PAR TOUS LES SAINTS GLORIFIES ',
      'contenu': '''1/ Par tous les saints glorifiés 
Jésus inspire leurs louanges 
Plus belle que le chant des anges 
Gloire à l’Agneau (ter) sacrifié !

2/ C’est par lui qu’est justifié  
Tout pécheur qui demande grâce 
Prêtres et rois devant sa face, 
Chantons l’Agneau (ter) sacrifié ! 

3/Par le père magnifié, 
Tout l’univers lui rend hommage 
L’Agneau règnera d’âge en âge, 
Gloire à l’Agneau (ter) sacrifié ! 

4/ Par son Esprit vivifié, 
Je veux jusqu’à ma dernière heure 
Chanter l’amour qui seul demeure, 
Gloire à l’agneau (ter) sacrifié ! 

5/ Pour nous Il fut crucifié 
Son sang a racheté notre âme 
C’est pourquoi notre amour l’acclame 
Gloire à l’Agneau (ter) sacrifié !  ''',
    });

    await db.insert('chants', {
      'langue': 'Moore et Autres',
      'titre': 'PËGRE LA NAAM ',
      'contenu': '''1. Pêgre la naam, waogre la panga 
Be ne a soaba sen zao,  
Sen zao geere zugu. 
La ne pebila wakat sên ka seta  

🎵Refrain: Bass 
Pêgere, panga be ne 
A saoba sên zao geer zugu 
La nePebila wakat 
Sên ka seta ye 
Refrain: Tenor  
Pêgere, panga be ne a saoba 
zugu la ne Pebila 
wakat sên ka seta ye 

2/Gese Wênnam yiiri be neba suka 
Jesus na zind ne bâmba 
La bâmb na yi bamb denda. 
Bamb na yens nintâm 
T’a kon leben zindi ye.  
La kuum la sû sâongo 
Wala yambre wala toogo 
Kon leben zindi yesa 
boêyinga denem bumb faân 
looga me. 

🎵Refrain: Bass 
Sû sâongo, yâmbre, toogo 
Kon le zindi yesa tengnoogo 
Puga boê yinga 
Denem bumb fân loogame. 

🎵Refrain:Ténor 
Sûsâongo, yâmbre,walatoogo 
Kon le zindiye. 
Denembumbfânloogame. 

3.   O Nom Divin, Nom rédempteur 
Jésus, puissant Sauveur ! (2x) 
Nous prosternant tous devant toi. 
Nous te couronnons, Roi (2x) 
C’est toi Jésus, c’est toi 
Que nous couronnons Roi. 

🎵Refrain : Ténor 
Divin Roi ! Jésus, c’est toi 
Jésus  
C’est Toi, Jésus oui ! C’est toi 
Que nous couronnons Roi. 

🎵Refrain : Bass 
Divin Roi ! Jésus, c’est toi  
Seul que nous couronnons Roi 
oui ! 
C’est Toi que nous couronnons 
Roi. 

4/jésusyellegese : mam watataotao ; 
Barka be asoabazugu 
Sen sakdaSebragoama. 
La keore be ne mam 
Tikonnedkamfân 
Sênzemsamengtumde 
Ne bumbningasênyabumbninga. 
Hakikawatataotaoamina! 
Bi wazu-soabaZezi! Bi waZizi! 

🎵Refrain 4 Bass : 
Sênzemsatumde Ne bumbninga 
Hakika! Mam  watataotao. amina! 
Bi wazu-soabaZezi! Bi waZizi ! 

🎵Refrain: 4Ténor: 
Sênzemsatumde 
Sênzemsatumdeninga 
Watataotao. amina! 
Bi wazu-soabaZezi! Bi waZizi!  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'PERE ETERNEL ',
      'contenu': '''Père Eternel nous te louons  
De ce que tu nous as aimé 
Oh Dieu d’amour merci  
De nous avoir sauvés (bis)  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'PLUS DE CONDAMNATION ',
      'contenu': '''1/ Plus de condamnation, plus de condamnation pour tous 
ceux qui sont en Jésus-Christ ! 
De la loi du péché me voici libéré par la loi de l’Esprit ! Car 
L’œuvre impossible à la loi,  
C’est Dieu qui l’accomplit pour moi, quand son fils dans la 
chair vint triompher de la mort et du péché. 

🎵Refrain :
Alléluia, libéré, libéré, vraiment 
libéré ! Alléluia libéré car l’Esprit m’a libéré !

2/ Plus de condamnation, plus de condamnation Pour ceux qui  
sont conduits par l’Esprit Mes efforts vertueux, mon moi le  
plus pieux pour Dieu n’ont aucun prix ! Mais l’Esprit-Saint  
qui délivra Jésus des griffes du trépas 
M’affranchit du vieil homme et me rend fort  
Depuis qu’il règne en mon cœur !  

3/ Plus de condamnation, plus de condamnation, finis  
l’esclavage et la frayeur, Car Dieu nous a donné l’Esprit  
de liberté et non l’esprit de peur Par cet Esprit d’adoption  
plein d’assurance nous crions, Abbas-père nous sommes fils  
de Dieu héritiers du Roi des cieux 

4/ Plus de condamnation, plus de condamnation car Jésus nous 
rend plus que vainqueur. Qui nous condamnera ? Qui nous 
séparera de l’amour de son cœur ? Les contretemps, la faim, le 
froid sont là pour tremper notre foi, toute chose concourt au 
bien de ceux qui de tout cœur aime Dieu. ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'POURQUOI DONC CES NATIONS EN TUMULTE ',
      'contenu': '''1/ Pourquoi donc ces nations en tumulte et ces peuples qui grondent en 
vain, tous ces rois et ces princes qui luttent, rejetant l’Eternel et son Oint ? 
Secouant les entraves divines, ils voudraient être libres et forts, mais sur 
tout l’univers, sur les cieux les enfers, notre Dieu règne encore ! 

🎵Refrain : 
Notre Dieu règne encore, jamais son amour ne s’endort, les vents 
se déchaînent et nos cœurs sont en peine mais Dieu nous conduit jusqu’au 
port ! Notre Dieu règne encore, jamais son amour ne s’endort ! Ce qu’Il nous 
promet reste vrai pour jamais notre Dieu règne encore !  

2/ L’Eternel dans les cieux s’en amuse, il se moque, il rit d’eux, puis 
soudain, dans sa juste colère, il accuse ; sachez donc que je suis 
souverain ! J’établis sur ma Sainte montagne Jésus-Christ, le grand Roi 
juste et fort, oui pour l’éternité, Divine autorité ! Notre Dieu règne 
encore  

3/ Voyez Christ, engendré par le père, recevant l’univers de sa main 
gouvernant les confins de la terre, par son sceptre de fer souverain ! 
Obéissez-lui donc, Rois et juges, de peur qu’Il ne vous livre à la mort, 
mais heureux tous ceux qui se confient en lui ; Notre Dieu règne encore 

4/ Dans un monde où sévit la tourmente du désordre et de l’iniquité, que notre 
âme en Dieu soit confiante ; il est l’inébranlable rocher, la réponse aux chaos 
de la terre c’est le règne de Christ, l’âge d’or, notre sécurité c’est son autorité 
notre Dieu règne encore !  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'PRES DU TRONE DE LA GRACE ',
      'contenu': '''1) Près du trône de la grâce et de la paix 
J’ai reçu la promesse d’un Dieu parfait, 
En Jésus j’ai la victoire par sa mort expiatoire 
Près du trône de la grâce et de la paix 

🎵Réfrain :
Viens oh viens, viens avec moi, 
Viens oh viens, viens à la croix, à la croix viens et vois 
Viens mon frère, Viens ma sœur, Viens à la croix 

2) Fuis le monde, vanité des vanités : 
Point de paix pour l’âme en ses frivolités ; 
Par lui Satan nous opprime, nous conduisant à l’abîme  
Fuis le monde, vanité des vanités !  

3) Je veux être vaillant soldat du Sauveur 
Lutter combattre toujours avec ferveur 
Et remplis de confiance j’accepterai la souffrance,  
Je veux être vaillant soldat du Sauveur.  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'Quand Gronde La Tempête  ',
      'contenu': '''1/ Quand gronde la tempête sur l’onde sans limite 
Mon cœur épouvante redoute l’ouragan, 
Seigneur, viens à mon aide (bis) 
Ma barque est si petite, si grande que l’océan (bis)

2/ Seigneur à ta parole, soudain l’effroi me quitte, 
Le flot tumultueux s’apaise en un instant, 
Seigneur soit ma boussole (bis) 
Ma barque est si petite, si grande que l’océan (bis)

3/ La vague a fait silence l’étoile au ciel palpite,  
L’étoile de la paix, scintille au firmament, 
Joyeux chant s’élance (bis) 
Ma barque est si petite et toi Seigneur si grand (bis) ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'QUE FERAI-JE ',
      'contenu': '''Que ferai-je pour remercier le Seigneur ? 
Chantons glorifions-le Ossiana 
Veille sur moi sur ma santé  
A chaque instant dans tous les lieux 
Dès lors si joyeux pour cela chantons Alléluia  Ossiana 
  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'QUEL JOUR DE JOIE ',
      'contenu': '''1/ Quel jour de joie, et de bonheur,  
où pour toujours j’ai fait mon choix 
A Jésus j’ai donné mon cœur,  
désormais tout est neuf en moi !

🎵Refrain :  
Oh quel beau jour, oh quel beau jour Jésus remplit mon cœur d’amour 
Et pour toujours il m’a appris la joie de vivre par l’Esprit (alléluia)  
Quel beau jour, oh quel beau jour, Jésus remplis mon cœur d’amour ! 

2/ Le grand échange est accompli,  
Jésus a pris tout mon péché 
De sa nature, il m’a rempli,  
joie et victoire et pureté ! 

3/ Mon bien aimé, a pris ma main, 
de jour en jour il me conduit,  
plus jamais seul, sur mon chemin  
Christ est à moi je suis à lui !''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'QUEL REPOS CELESTE',
      'contenu': '''1. Quel repos céleste, Jésus, d’être à Toi ! 
A Toi pour la mort et la vie, 
Dans les jours mauvais de chanter avec foi : 
Tout est bien ma paix est infinie ! 

🎵Refrain 
Quel repos, quel repos, 
Quel repos, quel repos, 
Quel repos, quel céleste repos

2. Quel repos céleste ! mon fardeau n’est plus ! 
Libre par le sang du calvaire, 
Tous mes ennemis, Jésus les a vaincus, 
Gloire et louange à Dieu notre père !

3. Quel repos céleste ! Tu conduis mes pas, 
Tu me combles de tes richesses, 
Dans ton grand amour, chaque jour Tu sauras  
Déployer envers moi tes tendresses. 

4. Quel repos céleste, quand enfin, Seigneur, 
Auprès de Toi, j’aurai ma place. 
Après les travaux, les combats, la douleur, 
A jamais je pourrai voir ta face ! ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'QUI A SUSPENDU LA TERRE ?',
      'contenu': '''1/ Qui a suspendu la terre dans le vide ? Oh quel mystère 
C’est mon Dieu qui la tient dans sa main ! 
Tous les jours et les années, de ma frêle destinée 
C’est mon Dieu qui la tient dans sa main ! 

🎵Refrain 
Je suis dans sa main, Je suis dans sa main 
Sa grâce est nouvelle chaque jour soir et matin 
Et dans son amour il me tient toujours 
Me protège de tout piège par sa forte main

2/ Quand le diable par le doute veut m’écarter de la route 
Dieu me guide par sa sûre main, 
Il parle à ma conscience, et j’ai pleine confiance 
Car je sais que je suis dans sa main 

3/ Plus jamais je ne me ronge de soucis, c’est du mensonge 
Car Dieu pourvoit par sa bonne main  
Spectre de la solitude, fuis sous d’autres latitudes 
Car je tiens de Dieu la tendre main !''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'REDEMPTEUR DU MONDE',
      'contenu': '''1/ Rédempteur du monde, Jésus Fils du Dieu Sauveur, 
Ta joie et ta paix m’inondent, Jésus mon libérateur.  
Réf : Merci notre Père d’avoir donné Jésus ton Fils 
et d’envoyer ta lumière par le Saint-Esprit

2/ Rédempteur du monde, crucifié pour mon péché, 
Ton amour, ta grâce abondent oh glorieux ressuscité ! 

3/ Un jour dans la gloire, je verrai ta face, 
Je vivrai sous ton regard, sauvé par ta grâce''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'REGNE EN MOI',
      'contenu': '''I. Libre de nos chaînes, 
Nous marchons vers Toi. 
Ta main souveraine 
Affermis nos pas. 
Armés de lumière 
Couronnés d’éclat, 
Soyons sur la terre  
Messagers de joie. 

🎵Refrain : 
Alléluia ! 
Que ton règne vienne, 
Maranatha ! 
Viens, Jésus, règnes en moi 

II. Proclamons sa grâce 
Au cœur de la nuit, 
Recherchons sa face  
Au cœur de sa vie. 
Célébrons sa gloire, 
Bannissons la peur, 
Chantons sa victoire, 
Jésus est vainqueur.''',
    });

    await db.insert('chants', {
      'langue': 'Moore et Autres',
      'titre': 'RIIM DAMBA RIIMA ',
      'contenu': '''Riim damba Riima (sid sida) yam ya zousoab dam zousoaba 
      Yam ya Wennam sen zemse ne pengre la waogre. (bis) 
      Yam ya tond bawennam yam ya sen ka sèbo 
      Yam pida ne panga la ziiri ya myuur sidya songo 
      Yam ya tond ba wennam yam ya sen ka sèbo 
      Yam sid ya ninbanzoere soaba yam pida ne nomglem. 
      Tond pengda yamba tond waogda yam your songo 
      (yam yuur songo) (Bis) ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'SANS JESUS JE NE PEUX VIVRE  ',
      'contenu': '''1. Sans Jésus je ne peux vivre,  
Je n’ose faire un seul pas 
C’est lui seul que je veux suivre,  
Pour lui seul vivre ici-bas ! 

🎵Refrain :  
Et mon cœur n’a rien à craindre,  
Puisque tu me conduiras 
Je te suivrai sans me plaindre  
En m’appuyant sur ton bras 

2.  Ton amour et ta promesse  
Remplissent mon cœur de foi 
Si je ne suis que faiblesse  
Je puisse être fort en Toi 

3. Enlève toute amertume  
Tout orgueil et lâcheté ; 
Que l’amour divin consume 
Tout mon être racheté.''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'SEIGNEUR JE VOUDRAIS ETRE A TOI ',
      'contenu': '''Seigneur je voudrais être à toi 
Dans ma vie quotidienne O Seigneur 
O accepte moi 
Soprane : Mon SEIGNEUR 
Tous : Accepte-moi (bis) ''',
    });

    await db.insert('chants', {'langue': 'Francais',
      'titre': 'SEIGNEUR MON ÂME SOUPIRE  ',
      'contenu': '''1. Seigneur mon âme soupir  
Après tes divins parvis 
Pour t’écouter et m’instruire 
A tes pieds toujours assis. 

🎵Refrain : 
Forme-moi pour ton service  
Ton école Oh Jésus ! 
Que par ton Esprit je puisse  
Prêcher ton nom aux perdus 

2. Seigneur, répands dans mon âme  
Flot sur flot de ton Esprit,  
Qu’ainsi brûlant de ta flamme  
En moi tout mal soit détruit.

3. Dans tes parcs herbeux fertiles, 
Nourris mon cœur affamé 
Qu’assis près des eaux tranquilles 
Par Toi je sois transformé. 

4. Seigneur tu sais toute chose,  
Je t’aime et je suis à Toi, 
De moi tout entier dispose, 
Je suis l’esclave du Roi. 
''' ,});
      
    
    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'SEIGNEUR, TU FUS NOTRE REFUGE ',
      'contenu': '''1. Seigneur, Tu fus notre refuge  
Dès les âges lointains 
De père en fils éternel Juge  
Tu règles nos destins 

🎵Refrain : 
Avant que le monde ne fût,  
Avant que le monde ne fût 
Ainsi que la terre, ainsi que la terre, 
Ainsi, ainsi que la terre, (A jamais à jamais) 
Tu es l’unique et même Dieu,  
D’éternité en éternité, A jamais le même,  
Tu es Dieu éternellement, à jamais le même.

2. Mille ans pour Toi, n’ont que l’espace 
D’un jour quand il n’est plus 
Ainsi qu’un songe bientôt passe 
Ils sont tous résolus 

3. Nous atteignons septante années,  
Les plus forts quatre vingt 
Et tout l’orgueil de nos journées 
N’est que peine et chagrins. 

4. Reviens Seigneur ; quand donc sera-ce ? 
Envers nous sois clément 
Fais succéder un temps de grâce 
Aux jours d’abaissement. 

5. Déploie à nos yeux la puissance 
De tes bras souverains 
Affermis dans ta bienveillance 
L’ouvrage de nos mains.''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'SEMONS DES L’AURORE ',
      'contenu': '''1- Semons dès l’aurore, (2x) 
Quand le soleil luit, (2x) 
Et semons encore lorsque vient la nuit  
Dieu peut faire éclore la fleur et le fruit. 

🎵Refrain : 
Bon courage, amis ! 
Bon courage, amis ! 
Nous irons joyeux cueillir les épis. 
Bon courage, amis ! 
Bon courage, amis ! 
Nous irons joyeux cueillir les épis. 

2- Semons pour le maître, (2x) 
Parlons du Sauveur,(2x) 
Semons, car peut-être un pauvre pécheur 
Par nous pourra naître au seul vrai bonheur. 

3-  La tâche est immense,(2x) 
Et dur le terrain,(2x) 
Mais, bonne espérance !  
Nul travail n’est vain, 
De Dieu la puissance fait germer le grain. 
''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'SERVEZ TOUJOURS L’ETERNEL ',
      'contenu': '''Servez toujours l’Eternel avec joie 
Sur le chemin montant et rocailleux 
Que le passant qui vous rencontre voie 
Le vrai bonheur scintiller dans vos yeux

Servez toujours l’éternel avec joie 
Si quelque épine a blessé votre main 
Bénissez donc celui qui vous l’envoie 
Et qui pour vous a le baume Divin 

Servez toujours l’Eternel avec joie 
Comme a servi Christ le vrai serviteur 
Restez joyeux pour que le monde voie 
Que ce service apporte le bonheur 

Servez toujours l’Eternel avec joie 
Quand la fatigue a ralenti vos pas 
Et que sa force en vos cœurs se déploie 
Faisant de nous d’indomptables soldats''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'SI TU CONFESSES TES PECHES ',
      'contenu': '''
1.Si tu confesses tes péchés (3x) Je te pardonnerai.  
2.Le sang de Christ peut rendre pur (3x) le cœur le plus mauvais. 
3.Dans ta faiblesse mon enfant (3x) ma grâce te suffit 
4.Et si tu passes par le feu (3x) avec toi je serai 
5.Je garderai ton cœur en paix (3x) en moi confie-toi.  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'SOUS UN CIEL TENEBREUX ',
      'contenu': '''1/ Sous un ciel ténébreux, là-haut sur la colline  
Symbole de notre salut 
Faite de bois rugueux, une croix se dessine, 
C’est là que Dieu pour nous mourut

🎵Refrain 
Vielle croix, bois maudit du calvaire 
Doux fardeau, joug facile et léger, 
Pour le suivre au chemin solitaire  
Le Sauveur m’invite à m’en charger. 

2/ Il gravit Golgotha, dans la peine et la honte, 
Courbé sous cet infâme bois ; 
Et maintenant il veut qu’à sa suite je monte, 
En portant avec lui sa croix 

3/ Il souffrit là, pour moi, le pécheur misérable  
Les tourments d’un horrible sort ; 
Il mourut, lui le Roi, pour l’esclave coupable 
Et j’ai la vie par sa mort.''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'SUR CHRIST LE ROCHER ',
      'contenu': '''1/ Ma foi n’est bâtie sur rien d’autre 
Que le sang la justice de Christ 
Je ne puis me fier à ce monde  
Mais au puissant nom de Jésus 

🎵Refrain 
Sur Christ le rocher je me tiens 
Le reste n’est que sable mouvant 
Le reste n’est que sable mouvant 

2/ Quand l’obscurité voile sa face 
Sa grâce pour moi ne change pas 
A tout vent et à tout orage, 
Mon ancre tient bien fermement 

3/ Sa promesse sa fidélité 
Dans la tempête me rendent vainqueur 
Quand autour de moi tout s’envole, 
Elles sont mon espoir mon soutient 

4/ Alors au son de la trompette 
Je veux s’être trouvé en lui 
Et vêtu de sa justice,  
Je me tiendrai devant son trône  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'SUR LE CHEMIN VAS SANS PEUR ',
      'contenu': '''1- Sur le chemin vas sans peur 
Car Jésus est devant toi 
Il veut être ton Sauveur 
Oh suis-le ; oh suis-le par la foi 

🎵Refrain 
Et maintenant saisis la main de ton Sauveur 
Car lui seul te donne l’éternel bonheur 
Il a donné sa vie sur la croix 
Oh suis-le ; oh suis-le par la foi 

2- Si le tentateur survient 
Regarde à Jésus et crois 
Il est dans le lieu très Saint 
Et Il prie, et Il prie pour toi 

3- Un jour Jésus reviendra 
Oh quel immense bonheur 
Dans son ciel il te prendra 
Bénis-le,  bénis-le dans ton cœur   ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'SUR LES PAS DU SAINT MODELE  ',
      'contenu': '''1. Sur les pas du Saint modèle, 
Nous marchons, comptant sur Lui, 
Et son cœur toujours fidèle 
Nous accorde son appui. 
Il connait notre faiblesse ; 
Lui toujours demeure fort, 
Et nous livre avec largesse 
Le meilleur de son trésor. 

2. Il nous donne sa vaillance 
Pour monter vers les sommets ; 
Si l’un tombe en défaillance, 
De ce faible il vient plus près. 
Sur le bord du précipice 
Il nous tient plus fortement. 
C’est ainsi que nul n’y glisse 
Qui sur lui compte vraiment. 

3. Avec nous venez sans crainte 
Sur les pas de ce Sauveur, 
Suivons tous la route sainte, 
Car déjà c’est le bonheur. 
Et plus haut plus loin des plaines, 
Avec lui montons toujours, 
Car ses mains sont toujours pleines 
Pour qui veut son grand secours.  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'SUR TES MURS ',
      'contenu': '''Sur tes murs j’ai placé des gardes O Jérusalem ! 
Jamais ils ne se tairont, ni jour ni nuit  
Bass/Ténor : passez par les portes préparez la voie,  
préparez la voie pour le peuple 

Frayez la route, frayez la route et ôtez-en les pierres ! 
🎵Basse : Elevez bien haut ! 
🎵Ténor/ Basse : Elevez bien ! 

Une bannière parmi le peuple ! 
Alléluia, Alléluia, Alléluia Amen ! 
Alléluia, Alléluia, Alléluia Amen  
(Amen, Amen, Amen) A-AMEN !  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'TA FIDELITE ',
      'contenu': '''1/ Dans nos cœur Christ habite avec gloire et puissance. 
Et son Esprit nous rassemble dans son amour fidèle. 
Tous de la famille de Christ, unis par son amour, 
Nous annonçons les merveilles du Dieu grand et fidèle 

🎵Refrain : 
Ta fidélité, ô Dieu, notre père est pour l’éternité, 
Pour ceux qui espèrent en Toi, en Ta grâce, 
En ta grande bonté ! Dieu Tu marches à notre tête, 
Nous te suivons d’un même cœur. 
Unis par ton Divin amour pour la couronne de vie. 

2/ Elus du royaume céleste, de Christ nous sommes  
L’église son alliance dure à jamais. Notre Dieu se révèle. 
Les ténèbres sont sous nos pas, les prisons sont ouvertes, 
La lumière de Christ éclaire notre marche en avant. 

3/ Fidèle, Christ un jour reviendra nous prendre avec lui   
Auprès du père, nous serons dans la félicité. 
Avec les anges et tout le ciel, nous chanterons en chœur  
L’hymne des grands vainqueurs en Christ 
Déjà réjouissons-nous.  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'TENONS NOS LAMPES PRETE ',
      'contenu': '''Tenons nos lampes prêtes  
Chrétiens préparons-nous 
Pour l’heure où les trompettes  
Annonceront l’époux 

🎵Refrain 
Qu’à répondre on s’empresse 
Hosanna, Hosanna 
Et qu’avec allégresse on chante alléluia 
On chante alléluia

Voici déjà les anges  
Avec eux les élus 
Unissant leurs louanges 
En l’honneur de Jésus 

Voici Jésus lui-même  
Puissant victorieux 
De son pur diadème 
L’éclat remplit les cieux

Venez bénis du père 
Qui m’avez entendu 
Entrez dans la lumière 
Le ciel vous est rendu  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'TON EGLISE ',
      'contenu': '''🎵Prélude : 
      L’amour comme un soleil divin 
Rayonnant tout sur son chemin 
Dieu est amour s’il vit en nous 
Un rayon de soleil bien doux 
Bien doux luira sur tous 

1. Voici Seigneur ton église en prière  
Devant ton trône incliné à genoux 
D’un même cœur elle vient toute entière 
Te demander de bénir ces époux 

🎵Refrain : 
Sur cette sœur et sur ce frère 
Répands les dons de ton amour 
Guide leurs pas dans ta lumière  
Que ta grâce en leur cœur abonde chaque jour

2.  En ce beau jour ils cherchent ta présence 
Viens de ta main sceller ces nœuds si doux 
Qu’en leur foyer règnent paix  espérance 
Daigne donc venir sceller ces deux époux 

3.  Ils t’ont choisi tous les deux pour leur maître  
Pour leur appui, leur guide et leur Sauveur 
Car en ce jour, les vœux de tout leur être 
C’est d’obtenir Ta divine faveur  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'TON EGLISE TRIOMPHANTE ',
      'contenu': '''1) Ton église triomphante o Saint Agneau ! 
Dans ton ciel une voix chante gloire à l’Agneau ! 
A lui le sceptre et le trône à lui l’encens la couronne que ce 
chant toujours résonne gloire à l’Agneau !

2) O merveilleuse harmonie : devant l’Agneau ! 
Toute l’église est unie…gloire à l’Agneau ! 
Rassemblé de toutes races, Sauvé par la même grâce 
Jamais ce chœur ne se lasse, gloire à l’Agneau ! 

3) Racheté de vos louanges devant l’Agneau ! 
S’unissent aux chœurs des anges gloire à l’Agneau !  
Gloire à la Sainte victime son sang lava notre crime 
Et nous sauva de l’abîme gloire à l’Agneau ! 

4) Dès maintenant sur la terre chantons l’Agneau ! 
Adorons, le Saint mystère gloire à l’Agneau ! 
Dans l’épreuve et la souffrance chantons la douce espérance 
De l’entière délivrance gloire à l’Agneau !''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'TOUT EST POSSIBLE A CELUI QUI CROIT  ',
      'contenu': '''1/ Tout est possible à celui qui croit. C’est la loi de la foi 
Don merveilleux qui nous vient des cieux. 
Que connait le cœur droit.

🎵Refrain :  
Oh ! Quel riche trésor ! Un cœur qui vit ce que Dieu dit : 
Sa foi vaut plus que l’or, Dieu l’honore et le bénit. 

2/ Quand l’ennemi fait trembler la peur. En face du danger, 
Croire au Seigneur, affermit le cœur. La foi fait triompher.

3/ Dieu manifeste à celui qui croit. La force de son bras ; 
Le Tout-Puissant dit à son enfant : Si tu crois, tu verras.   ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'TOUT LE MONDE ENTIER  ',
      'contenu': '''Tout le monde entier, adorons  
Louons son nom, nous tous qui sommes sur la terre 
Parce que son amour est grand pour nous et les merveilles de 
l’Eternel sont bonnes 
Adorons, notre Dieu (bis) 
Adorons notre grand Dieu  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'TRIOMPHONS  ',
      'contenu': '''1/ Triomphons, chantons d’allégresse, 
Réjouissons-nous devant Dieu 
Qu’un chant de louanges sans cesse 
A sa gloire monte en tout lieu ! 

🎵Refrain : 
Triomphe, Triomphe, 
Tressaille de joie en ton Dieu 
Triomphe, Triomphe,  
Tressaille de joie en ton Dieu

2/ Chantons à celui qui s’avance,  
Dans les cieux, les cieux éternels 
Il fait entendre avec puissance  
Sa voix, c’est le Dieu d’Israël !

3/ Il donne à son peuple victoire,  
Puissance, force, liberté 
A notre Dieu rendons la gloire, 
Louons sa Sainte majesté ! 

4/ De concert avec les Saint anges, 
Faisons retentir notre voix 
Chantons à jamais les louanges,  
De l’Agneau divin mis en croix !  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'TU ES DIGNE ',
      'contenu': '''🎵Refrain :
Tu es digne (3) d’être adoré 
Tu es digne (3) d’être adoré 

1- Dans  les  cieux  et  sur  la  terre  
Il n’y en a point comme toi Jésus  
Tu es mort et ressuscité  
Tu m’as donné la vie éternelle 

2- Dès le matin, je chante ton Nom 
Dans  la journée je célèbre ta gloire 
Avant le couché je te rends grâce 
Je telouerai toute ma vie Jésus 

3-   Toutes tes bontés ne sont point finies 
(Elles) se renouvellent chaque matin 
Ma vie abonde de ta grâce  
Reçois Seigneur mon adoration 

4-A Golgotha où tu mourus 
Tu pris sur toi tous mes péchés
Tu me donnas ton salut
Recois Seigneur ma vie en retour ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'TU ES MERVEILLEUX ',
      'contenu': '''🎵Refrain :
       Tu es merveilleux tes œuvres sont merveilleuses 
Tout ce que tu fais Seigneur est merveilleux  (bis) 

1/Dans la nature autour de nous  
Tout ce qui tu fais Seigneur est merveilleux 
2/Dans le sourire dans mon problème….. 
3/Oui dans ma vie de tous les jours……. 
4/Oui dans la vie de ton église……. 
5/Oh tu es merveilleux ton amour est merveilleux……. 
6/Tu es merveilleux ton salut est merveilleux……… 
7/Tu es merveilleux ta présence est merveilleuse 
Tout ce que tu fais Seigneur est magnifique 
8/Tu es merveilleux tes enfants sont merveilleux….. 
9/Tu es merveilleux ta paix est merveilleuse……. 
10/Tu es merveilleux tes œuvres sont glorieuses…….  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'TU LES BENIS ',
      'contenu': '''1. Tu les bénis, fidèle et tendre père,  
Ces chers enfants, gage de ton amour ; 
Ils viennent remplir leurs tâches sur la terre : 
Se préparer au céleste séjour  
Jésus nous a révélé sa tendresse : 
« Laissez venir à moi tous les petits » 
Ils t’appartiennent nous avons ta promesse 
Que ton royaume, ô Seigneur, est à eux. 

2. Ah qu’ils sont grands dans leur faiblesse extrême : 
Tu les as aimés de toute éternité 
Ils portent en eux ton image elle-même, 
Et de ton fils le sang les a rachetés ! 

3. Qui sommes-nous pour former ses jeunes âmes, 
Pour leurs montrer le chemin du salut, 
Leur faire aimer ce que ta loi réclame 
Et les guider pas à pas vers le but ? 

4. Tu mets sur eux, Seigneur, ta main puissante 
Pour les garder, puisqu’ils sont tes enfants ; 
Et dès ce jour ta grâce prévenante 
Prépare en eux les chrétiens triomphants.  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'UN BEAU JOUR LE MONDE SERA CONFONDU  ',
      'contenu': '''1/ Un beau jour le monde sera confondu 
On nous cherchera partout, disparu, 
Car nous qui sommes sauvés et marchons en sainteté, 
En un clin d’œil, nous serons enlevés, 

🎵Refrain :   
Enlevé, enlevé, en un clin d’œil nous serons tous enlevés, 
Enlevé, enlevé, auprès de Jésus nous serons enlevés.

2/ La trompette du Seigneur sonnera, 
La voix de l’archange retentira, 
Jésus viendra sur la nue, tous ensembles à sa venue, 
En un clin d’œil, nous serons enlevés, 

3/ Nous ne devancerons pas ceux qui sont morts 
Ils sortiront de leurs tombes d’abord, 
Mais je vous dis un secret, à vous qui êtes prêts : 
En un clin d’œil, nous serons enlevés, 

4/ Alors nous revêtirons des corps nouveaux, 
Immortels filles, et fils du Très - haut, 
Triomphants, nous chanterons, mort où est ton aiguillon ? 
En un clin d’œil, nous serons enlevés, 

5/ Dans l’épreuve la tristesse et les soucis, 
Quelle force de marcher nous aussi, 
Bientôt nous irons là-haut, loin des peines et des fardeaux 
En un clin d’œil, nous serons enlevés,  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'VENEZ CŒURS SOUFFRANTS ET MEURTRIS  ',
      'contenu': '''1/ Venez cœurs souffrants et meurtris 
Au médecin de l’âme 
Par Jésus vous serez guéris 
Que votre voix l’acclame 

🎵Refrain : 
Nom célébré par les élus ; 
Adoré par les anges, 
Thème éternel de nos louanges 
Jésus ! Jésus ! Jésus ! 

2/ En christ nous sommes pardonnés ; 
C’est la bonne nouvelle 
Par lui les cieux nous sont donnés 
Et la vie éternelle 

3/  Vous tous qui souffrez isolés, 
Venez Jésus vous aime 
Pour le troupeau des désolés 
Il s’est offert lui-même

4/  D’un seul corps d’une seule voix 
Exaltons sa victoire  
Et dans le ciel du Roi des rois 
Nous redirons sa gloire  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'VIENS, AME QUI PLEURE ',
      'contenu': '''1. Viens âme qui pleure, Viens à ton sauveur ; 
Dans tes tristes heures, Dis-lui ta douleur. 
Dis tout-bas ta plainte, Au Seigneur Jésus, 
Parle-lui sans crainte, Et ne pleure plus. 

2. Dis tout à ce frère, à ce tendre ami, 
Ton épreuve amère, ton deuil, ton souci. 
Il aime, Il console, Les âmes abattues ; 
Crois à sa parole, et ne pleure plus. 

3. Aux cœurs en détresse, Ployant sous le faix, 
Dis que Dieu les presse, De chercher sa paix. 
Calme leurs alarmes ; Dis-leur que Jésus 
a séché nos larmes… Vas, ne pleure plus   ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'VOICI JE VIENS BIENTOT  ',
      'contenu': '''Refrain : 
      Voici je viens bientôt a dit le Seigneur 
Voici je viens bientôt veillez et priez 

1/ Oh mes amis vous ne savez ni le jour ni l’heure 
Pour cela gardez la foi, veillez et priez 

2/ En attendant ce beau jour parlons du Sauveur 
Toi ma sœur ou toi mon frère, sois un vrai témoin

3/ Alléluia quelle joie, pour tous les élus 
Alléluia quel bonheur bien être en Jésus 
  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'VOYEZ LE CHRIST SUR LA NUE ',
      'contenu': '''1. Voyez le Christ sur la nue  
Descendre en triomphateur 
Chantez ! L’aurore est venue 
L’aurore d’un jour meilleur 
Sur la nue, sur la nue, sur la nue, 
Voici notre rédempteur 

2. Il vient le monde à sa vue 
Frémit de crainte et d’effroi 
Le voici ! que sa venue 
Est douce au cœur plein de foi 
Sur la nue, sur la nue, sur la nue,  
Voici, voici notre Roi 

3. De l’éclat de sa venue  
Le ciel même est ébloui 
Chante ! Eglise méconnue 
Le jour du triomphe a luit 
Sur la nue, sur la nue, sur la nue,  
Tu vas régner avec lui  ''',
    });

    await db.insert('chants', {
      'langue': 'Moore et Autres',
      'titre': 'OYE (Langue Ashanti) ',
      'contenu': '''A sem papa bia mati Oye Oye
A sem papa bia mati ne se Yesu yeɔ do (Ampa)
Oye (Edjo Nyame ye) Oye ampa
Oye Oye Oye

🎵Ténor : Mom ma yem bo’m n’kasse

Oye (Oye) Oye (Oye)
Me kwra son wri nan to gnon’m se Oye (Ampa)
Oye (Edjo Nyame ye) Oye ampa
Oye Oye Oye

🎵Alto : Che gnia waye mio
Bra no bedje wo n’so

🎵Ténor : Meka Meka Meka Meka

🎵Basse : Mian pa na me gno
Oye’obatanpa pa


🎵Traduction

J’ai trouvé le vrai bonheur, gloire ! Gloire !
J’ai trouvé le vrai bonheur, vraiment Jésus m’aime. Gloire ! Gloire !
Gloire !

Proclamons tous en chœur : Gloire ! Gloire ! Gloire !

Lève-toi, mon âme, proclame le Seigneur. Gloire ! Gloire ! Gloire !

Il donne la vie, il prendra soin de moi. Gloire ! Gloire ! Gloire !

Chantez, chantez, chantez Gloire ! Gloire ! Gloire !

C’est mon protecteur ; il est toujours près de moi. Gloire ! Gloire !

Gloire !  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'SEIGNEUR QUE N’AI-JE MILLE VOIX',
      'contenu': '''1. Seigneur que n'ai-je mille voix
Pour chanter tes louanges,
Pour chanter tes louanges,
Et faire monter jusqu'aux anges
Les gloires de ta croix,
Les gloires de ta croix,
Les gloires de ta croix !

2. Jésus, mon Seigneur et mon Dieu,
Que ton souffle m'anime,
Que ton souffle m'anime
Pour que par moi ton Nom sublime
Retentisse en tout lieu,
Retentisse en tout lieu,
Retentisse en tout lieu !

3. Doux Nom qui fait tarir nos pleurs,
Ineffable harmonie,
Ineffable harmonie,
Tu répands la joie et la vie
Et la paix dans nos cœurs,
Et la paix dans nos cœurs,
Et la paix dans nos cœurs !

4. Désormais, je n'ai plus d'effroi,
Aucun mal ne m'accable ;
Aucun mal ne m'accable ;
Ton sang rend pur le plus coupable ;
Ton sang coula pour moi,
Ton sang coula pour moi,
Ton sang coula pour moi !  ''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'Albinos Noir ',
      'contenu': '''Mais qui est cet albinos noir ?
En effet il est un fœtus, voire un fruit
Que porte le territoire,
Travaillant dans la paix sans bruit.

🎵Refrain
Que porte le territoire, (9 fois)
Travaillant dans la paix sans bruit.  ''',
    });

    await db.insert('chants', {
      'langue': 'Moore et Autres',
      'titre': 'Ndabula ',
      'contenu': '''
Ndabula mbondi kutembaula tata'a amoye omwe (2fois)
Ensemble d'un coeur entonnons un cantique au grand roi (2fois)''',
    });

    await db.insert('chants', {
      'langue': 'Francais',
      'titre': 'MOI ET MA MAISON NOUS SERVIRONS L’ÉTERNEL',
      'contenu': '''Choisissez (choisissez) aujourd’hui qui vous suivrez (vous suivrez)
Choisissez aujourd’hui (mes frères) qui vous servirez (servirez)
Choisissez (choisissez) aujourd’hui qui vous suivrez (écoutez)
Choisissez aujourd’hui qui vous servirez.

Ou les dieux de vos pères, ou les dieux étrangers
Ou les dieux de vos pères, ou les dieux étrangers (Je dis)

Refrain

Moi et ma maison, moi et ma maison
Moi et ma maison nous servirons l’Éternel. (Sachez que) 2x

Chœur

L’Éternel des armées, Dieu le créateur de l’univers (B)
Moi et ma maison nous servirons l’Éternel (SATB)

L’Éternel des armées, Dieu le créateur de l’univers (B + T)
Moi et ma maison nous servirons l’Éternel (SATB)

Pont

Sachez que (B) :

Moi et ma maison, moi et ma maison
Moi et ma maison nous servirons l’Éternel.

Je dis (T) :

Moi et ma maison, moi et ma maison
Moi et ma maison nous servirons l’Éternel.

Moi et ma maison, moi et ma maison
Moi et ma maison nous servirons l’Éternel 2x''',
    });

    await db.insert('chants', {
      'langue': 'Moore et Autres',
      'titre': 'JESUS VUUGRE ',
      'contenu': '''1.
Bamb bee yaogo puga, Jesus mam Dima,
Gùnda vuugre daare, Mam Fâageda.

Refrain :
Viim soaba Bamb base kuum
La Bamb tôoge Bamb beeba buud fáa.
Jesus sâam kuum pânga, la Eb vuugame
Jesus yaaViim soaba, la B na vuuge tond.
Bamb vuuge, Bamb vuuge,
Alleluia! Bamb vuuge.

2.
Neba gùn bamb yaogo, Jesus mam Dima,
Bamb page ne kugri, Mam Fâageda.

3.
Kuum ka toê talle Bamb, Jesus mam Dima,
Bamb sâam kuum pang afâa, Mam Fâageda.''',
    });

    await db.insert('chants', {
      'langue': 'Moore et Autres',
      'titre': 'Mam ka na n sînd m noore ',
      'contenu': '''Mam ka na n sînd m noore mam Ba taoré (mam na n yii)

N pẽnge bãmb yũure n waoge Bãmb yũure (t, boẽn)

Bãmb mãan neer mam yĩnga sid ya koẽnga.

Mam ka na n sînd m nõore mam Ba taoré (mam na n yeel)

Ti bãmb zemsa me wakat bùud fãan (sĩda)

Pẽngre, naam, la waogre, pãnga, la ziiri.

Bãmb kogla mam (vĩim), n kõ m laafi, n kõ m pãnga, n kõ m riibo

Bãmb gesa mam yell wakat fãan, hal ti ta moasãn. (Bis)

Ba a Wennam, ne m sùur fãan, mam pùusda Yãmb, y barka

Rĩim dãmba rĩima, Yãmb zemsa me ti ri naam wakat fãan. (Bis)'''
      });

await db.insert('chants', {
      'langue': 'Moore et Autres',
      'titre': 'Siin vouusidi nin yonre fan',
      'contenu': '''
Siin vouusidi nin yonre fan ,pinge wennam, bamb tongeda niin worgre

Siin vouusidi nin yonre fan ,pinge wennam, bamb tongeda niin worgre'''      });


} //Fin de la boucle If
}//fin de insertion par defauts



  // Récupérer tous les chants d'une langue
  Future<List<Chant>> getChantsByLangue(String langue) async {
    final db = await database;

    final result = await db.query(
      'chants',
      where: 'langue = ?',
      whereArgs: [langue],
      orderBy: 'titre',
    );

    return result.map((map) => Chant.fromMap(map)).toList();
  }

  // Récupérer un chant par son ID
  Future<Chant?> getChantById(int id) async {
    final db = await database;

    final result = await db.query(
      'chants',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Chant.fromMap(result.first);
    }
    return null;
  }

  //Recuperation des favoris
  Future<List<Chant>>getFavoris()async{
    final db = await database;
    final result = await db.query(
      'chants',
      where: 'favori =?',
      whereArgs:[1],
      orderBy:'titre'
    );
    return result.map((map) =>Chant.fromMap(map)).toList();
  }
  
} //fin de la base de donnees
