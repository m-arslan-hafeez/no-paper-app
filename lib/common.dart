import 'package:responsive_builder/responsive_builder.dart';
import 'package:toast/toast.dart';

void showToast(context, String message) {
  Toast.show(message, context, duration: 3, gravity: Toast.BOTTOM);
}

bool isMobile(context) {
  return getValueForScreenType<bool>(
      context: context, mobile: true, tablet: true, desktop: false);
}
bool isTablet(context) {
  return getValueForScreenType<bool>(
      context: context, mobile: false, tablet: true, desktop: false);
}
String alertText =
    "Consapevole delle conseguenze penali previste in caso di dichiarazioni mendaci a pubblico ufficiale (art. 495 c.p.) dichiaro sotto propria responsabilita\' che \n\n \u2022 negli ultimi 14 gg non ho avuto un contatto stretto con paziente COVID, non ho avuto un contatto stretto con una o più persone con febbre e/o sintomi respiratori(casa, ufficio, lavoro, .. ), \n\n \u2022 di non avere ricevuto disposizioni di isolamento fiduciario o di quarantena, non essere rientrato in Italia, nè avere avuto contatti stretti con persone che sono rientrate da un paese extraUE, extra Schengen, Croazia, Grecia, Malta, Spagna, Francia, Belgio, Paesi Bassi, Regno Unito di Gran Bretagna e Irlanda del Nord, Repubblica Ceca. \n\nDi non presentare sintomi di febbre e/o dolori muscolari diffusi, sintomi delle alte e basse vie respiratorie: tosse, mal di gola, difficoltà respiratorie, sintomi gastrointestinali (diarrea, nausea, ecc.), disturbi della percezione di odori e gusti (anosmia, disgeusia). \n\nIn caso variassero le condizioni di cui alla presente certificazione, mi impegno a darne tempestiva comunicazione al personale di questa struttura.";

String privacyText =
    '  La nostra Cookie Policy ha l\'intento di descrivere le tipologie di cookie utilizzati dalla nostra applicazione NOPAPER \n\n (di seguito Applicazione), le finalità, la durata e le modalità con cui l\'Utente può gestire i cookie presenti. Il titolare del trattamento dei dati personali è \n\n Paltolab s.r.l. \n\n Partita Iva 14472351007 \n\n 00156 Via Carlo Arturo Jemolo 83, Roma \n\n info@paltolab.com (di seguito il Titolare). \n\n I cookie sono stringhe di testo di piccole dimensioni che vengono memorizzate sul dispositivo dell\'Utente quando naviga in rete. \n\n I cookie hanno lo scopo di raccogliere e memorizzare informazioni relative all\'Utente al fine di rendere l\'Applicazione più semplice, più veloce e più aderente alle sue richieste. \n\n Con il termine cookie si vuol far riferimento sia agli stessi cookie sia a tutte le tecnologie similari. \n\n Questa Applicazione non fa uso di cookie che raccolgono dati dell\'Utente. ';

/*
String privacyText = "Paltolab s.r.l. con sede legale in Via Carlo Arturo Jemolo 83, 00156 Roma, P. IVA 14472351007 \n (in seguito Titolare), in persona del legale rappresentate pro tempore, in qualità di TITOLARE DEL TRATTAMENTO, La informa ai sensi dell\’art. 13 \n del Regolamento UE n. 2016/679 (in seguito GDPR) che i dati da Lei forniti saranno trattati con le modalità e per le finalità seguenti";
privacyText += "1. Oggetto del trattamento \n";

privacyText += "Il Titolare, per affrontare l’emergenza sanitaria in corso e la gestione dei rapporti con Lei in corso, tratta i Suoi dati personali, identificativi, di contatto (ad esempio: nome, cognome, telefono);";
2. Finalità del trattamento e base giuridica
I Suoi dati personali non particolari sono trattati esclusivamente per le finalità di conservazione nel c.d. “elenco presenze” istituito dalle
“Linee di indirizzo per la riapertura delle Attività Economiche, Produttive e Ricreative” approvate dalla Conferenza Stato-Regioni e dalle Linee Guida
della Regione.
3. Base giuridica
I Suoi dati personali, identificativi e di contatto, sono trattati senza il Suo consenso per adempiere un obbligo legale al quale è
soggetto il titolare (art. 6, par. 1, lett. c Reg. UE 679/2016) nonché necessario per la salvaguardia degli interessi vitali
dell&#39;interessato o di un&#39;altra persona fisica (art. 6, par. 1, lett. d Reg UE 67972016), in ottemperanza dei citati
provvedimenti normativi.
4. Natura del conferimento dei dati e conseguenze del rifiuto di rispondere
Il conferimento dei dati per le finalità di cui al punto 2.a) è obbligatorio e non necessita di consenso. In assenza di tali dati
il titolare potrebbe non garantirLe la prenotazione/erogazione del servizio.
5. Accesso ai dati
I Suoi dati potranno essere resi accessibili per le finalità di cui al punto 2: ai dipendenti e collaboratori del Titolare nella loro
qualità di incaricati del trattamento o ad altri soggetti che svolgono tale attività per conto del Titolare nella loro qualità di
responsabili esterni del trattamento.
6. Comunicazione di dati
I dati non saranno né diffusi né comunicati a terzi al di fuori delle specifiche previsioni normative (es. in caso di richiesta
da parte dell’Autorità sanitaria, anche per la ricostruzione della filiera degli eventuali contatti stretti di un lavoratore
risultato positivo al COVID-19, protezione civile, ecc.). I Suoi dati non saranno diffusi.
7. Trasferimento di dati
I Suoi dati non saranno trasferiti al di fuori dell’Unione Europea.
8. Conservazione dei dati
In caso di prenotazione, i Suoi dati identificativi e di contatto verranno conservati per 14 giorni così come previsto dalle
normative richiamate.
9. Diritti dell’interessato
Ai sensi degli articoli da 15 a 22 del Reg. UE n. 679/2016, all’Interessato è conferita la possibilità di esercitare specifici
diritti. In particolare, l&#39;Interessato ha diritto a: a) ottenere la conferma dell&#39;esistenza di trattamenti di dati personali che lo
riguardano e, in tal caso, l’acceso a tali dati; b) ottenere la rettifica dei dati personali inesatti e l’integrazione dei dati
personali incompleti; c) ottenere la cancellazione dei dati personali che lo riguardano, nei casi in cui ciò sia consentito dal
Regolamento; d) la limitazione del trattamento, nelle ipotesi previste dal Regolamento; e) ottenere la comunicazione, ai
destinatari cui siano stati trasmessi i dati personali, delle richieste di rettifica/cancellazione dei dati personali e di
limitazione del trattamento pervenute dall’Interessato, salvo che ciò si riveli impossibile o implichi uno sforzo
sproporzionato; f) ricevere, in un formato strutturato, di uso comune e leggibile da dispositivo automatico, dei dati
personali forniti al Titolare, nonché la trasmissione degli stessi a un altro titolare del trattamento, e ciò in qualsiasi
momento, anche alla cessazione dei rapporti eventualmente intrattenuti col Titolare; g) opporsi in qualsiasi momento,
per motivi connessi alla sua situazione particolare, al trattamento dei dati personali che lo riguardano ai sensi
dell’articolo 6, paragrafo 1, lettere e) o f), compresa la profilazione sulla base di tali disposizioni. Qualora i dati personali
siano trattati per finalità di marketing diretto, l’interessato ha il diritto di opporsi in qualsiasi momento al trattamento dei
dati personali che lo riguardano effettuato per tali finalità, compresa la profilazione nella misura in cui sia connessa a
tale marketing diretto; h) non essere sottoposto a una decisione basata unicamente sul trattamento automatizzato,
compresa la profilazione, che produca effetti giuridici che lo riguardano o che incida in modo analogo significativamente
sulla sua persona; i) proporre reclamo a un’autorità di controllo ai sensi dell’art. 77. Può esercitare i Suoi diritti scrivendo
all’indirizzo mail del Titolare:
10. Responsabili esterni e incaricati
L’elenco aggiornato dei responsabili esterni e degli incaricati al trattamento è custodito presso la sede legale del
Titolare del trattamento.'
privacyText += '  La nostra Cookie Policy ha l\'intento di descrivere le tipologie di cookie utilizzati dalla nostra applicazione NOPAPER \n\n (di seguito Applicazione), le finalità, la durata e le modalità con cui l\'Utente può gestire i cookie presenti. Il titolare del trattamento dei dati personali è \n\n Paltolab s.r.l. \n\n Partita Iva 14472351007 \n\n 00156 Via Carlo Arturo Jemolo 83, Roma \n\n info@paltolab.com (di seguito il Titolare). \n\n I cookie sono stringhe di testo di piccole dimensioni che vengono memorizzate sul dispositivo dell\'Utente quando naviga in rete. \n\n I cookie hanno lo scopo di raccogliere e memorizzare informazioni relative all\'Utente al fine di rendere l\'Applicazione più semplice, più veloce e più aderente alle sue richieste. \n\n Con il termine cookie si vuol far riferimento sia agli stessi cookie sia a tutte le tecnologie similari. \n\n Questa Applicazione non fa uso di cookie che raccolgono dati dell\'Utente. ';
*/
