unm-ios
=======

_Application iOS UnivMobile_

Ce projet contient le code Objective-C / Xcode de l’application iOS UnivMobile.

Documentation parente : [unm-devel](../../../unm-devel/blob/develop/README.md "Documentation parente : unm-devel/README.md")

Documentation de même niveau :

  * [Développement : unm-ios](Devel.md "Documentation : unm-ios/Devel.md")

Documentation des sous-projets :

  * [unm-ios-it](unm-ios-it/README.md) — _Tests d’intégration de l’application iOS UnivMobile_

### Architecture logicielle

![](src/site/images/ios.png?raw=true =600x "iOS + Backend")

L’application iOS UnivMobile récupère les données JSON du backend
via une URL spécifiée avec le paramètre « UNMJsonBaseURL »
dans UnivMobile-Info.plist.

En développement :

    <key>UNMJsonBaseURL</key>
    <string>http://univmobile.vswip.com/unm-backend/json/</string>

En intégration continue :

    <key>UNMJsonBaseURL</key>
    <string>http://localhost:8380/unm-backend/json/</string>
    
En intégration :

    <key>UNMJsonBaseURL</key>
    <string>https://univmobile-dev.univ-paris1.fr/json/</string>
