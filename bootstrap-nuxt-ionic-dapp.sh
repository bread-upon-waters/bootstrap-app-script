#!/bin/sh
WORKING_DIR=$1
APP_ID=$2

cecho(){
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

    printf "${!1}${2} ${On_ICyan}\n"
}

cecho "BIGreen" ">>> Workinng with file system for $WORKING_DIR ..."

title=$(echo  $WORKING_DIR | tr '_-' ' ' | tr '[:upper:]' '[:lower:]' | sed -e "s/\b./\u\0/g")

#################################################################
# init
function pause(){
   read -p "$*"
}
#################################################################

#################################################################
WarningPrompt ()
{
	read -p " [You are about to bootstrap $title vue app!!! Press any key to contrinue, or abort now with break signal (CTRL-C)]"
}
#################################################################
WarningPrompt

if [ -d "$WORKING_DIR" ]; then 
    cecho "IGreen" ">>> Deleting $WORKING_DIR woking directory with its sub folders."
    rm -Rf $WORKING_DIR; 
    ##rm -Rf *; 
fi

mkdir  -p $WORKING_DIR

##  USING VITE - npm 6+,
npx nuxi init $WORKING_DIR

cd $WORKING_DIR

npm i -D nuxt-ionic
npm i

code .

echo "First initialize Ionic & integrate Capacitor before you continue..."
pause 'Press [Enter] key to continue...'

rm nuxt.config.ts
echo "import { defineNuxtConfig } from 'nuxt'

// https://v3.nuxtjs.org/api/configuration/nuxt.config
export default defineNuxtConfig({
    ssr: false,
    modules: ['nuxt-ionic'],
    ionic: {
        integrations: {

        },
        css: {
            basic: true,
            core: true,
            utilities: true
        }
    }
})" >> nuxt.config.ts

rm capacitor.config.json
echo '{
  "appId": "za.co.'$APP_ID'",
  "appName": "'$APP_ID'",
  "webDir": ".output/public",
  "bundledWebRuntime": false
}' >> capacitor.config.json

rm package.json
echo '{
  "name": "'$WORKING_DIR'",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "build": "nuxt build",
    "dev": "nuxt dev",
    "generate": "nuxt generate",
    "preview": "nuxt preview",
    "ionic:build": "npm run build",
    "ionic:serve": "npm run start"
  },
  "devDependencies": {
    "nuxt": "3.0.0-rc.5",
    "nuxt-ionic": "^0.2.2"
  },
  "dependencies": {
    "@capacitor/app": "1.1.1",
    "@capacitor/camera": "1.3.1",
    "@capacitor/cli": "3.6.0",
    "@capacitor/core": "3.6.0",
    "@capacitor/haptics": "1.1.4",
    "@capacitor/keyboard": "1.2.3",
    "@capacitor/status-bar": "1.0.8"
  }
}' >> package.json


# @rem npm i -S @ionic/vue @ionic/core

mkdir plugins
mkdir components

rm app.vue
echo '<template>
  <IonApp>
    <IonRouterOutlet />
  </IonApp>
</template>

<script setup>

    useHead({
    title: "'$APP_ID'",
    charset: "utf-8",
    viewport:
        "width=device-width. initial-scale=1, maximum-scale=1, viewport-fit=cover",
    });
</script>' >> app.vue

rm -Rf pages

mkdir pages
echo "<template>
  <IonPage>
    <IonHeader>
      <IonToolbar> 
        <IonTitle>Home</IonTitle>
        <IonButtons slot='end'>
          <IonButton>Logout</IonButton>
        </IonButtons>
      </IonToolbar>
    </IonHeader>
    <IonContent class=\"ion-padding\">
      <h1>THIS IS MY PAGE</h1>
      <IonButton @click='router.push(\"/about\")'> GO TO ABOUT PAGE </IonButton>
    </IonContent>
  </IonPage>
</template>

<script setup lang='ts'>
    definePageMeta({
        alias: ['/', '/home'],
    })

const router = useIonRouter();
</script>
" >> pages/index.vue

echo "<template>
  <IonPage>
    <IonHeader>
      <IonToolbar> <IonTitle>About</IonTitle></IonToolbar>
    </IonHeader>
    <IonContent class=\"ion-padding\">
      <h1>THIS IS MY ABOUT PAGE</h1>
      <IonButton @click='router.back()'> GO HOME </IonButton>
    </IonContent>
  </IonPage>
</template>

<script setup lang='ts'>
    definePageMeta({
        alias: ['/about'],
    })

  const router = useIonRouter();
</script>
" >> pages/about.vue

echo "<template>
  <IonPage>
    <IonHeader>
      <IonToolbar>
        <IonButtons slot=\"start\">
          <IonBackButton />
        </IonButtons>
        <IonButtons slot=\"end\">
          <IonButton>Image</IonButton>
        </IonButtons>
      </IonToolbar>
    </IonHeader>
    <IonContent class=\"ion-padding\">
      <h1>LOAD IMAGE</h1>
      <IonButton @click=\"takePicture()\"> Take Picture </IonButton>
      <IonImg :src=\"imageURL\" />
    </IonContent>
  </IonPage>
</template>

<script setup lang='ts'>
import { ref } from \"vue\";
import { Camera, CameraResultType, ImageOptions } from \"@capacitor/camera\";
useHead({
  script: [
    {
      type: \"module\",
      src: \"https://unpkg.com/@ionic/pwa-elements@latest/dist/ionicpwaelements/ionicpwaelements.esm.js\",
    },
  ],
});
definePageMeta({
  alias: [\"/picture\"],
});

const router = useIonRouter();

const imageURL = ref(null);

const takePicture = async () => {
  const image = await Camera.getPhoto({
    quality: 90,
    allowEditing: true,
    resultType: CameraResultType.Uri,
  });
  imageURL.value = image.webPath;
};
</script>
" >> pages/picture.vue

npm i -D ethers hardhat @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers
npm i
npx hardhat

cecho "IGreen" "
#### **************************************************** ####
>>> Done!!! bootstraping project nuxt $title project >>>
>>> Add <body class='antialiased min-h-screen'>     >>>
>>> cd $WORKING_DIR && npm i && npm run dev         >>>
>>> npm start >>> http://localhost:3000             >>>
#### **************************************************** ####

# Emulator appetize.io corellium.com developer.apple.com/xcode 
# developer.apple.com/testflight qemu, electonic plum
# Remoted IOS 