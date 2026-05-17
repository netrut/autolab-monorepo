Here's the setup for deploying customer_app on Vercel

1. Build command

cd /workspaces/autolab-monorepo/apps/customer_app && \
export PATH="$PATH:/home/node/flutter-sdk/flutter/bin" && \
flutter build web --release \
 --dart-define=API_URL=https://autolab-api.vercel.app

2. Git commit/push

cd /workspaces/autolab-monorepo/apps/customer_app
git add -f build/web
git commit -m "Customer app web build"
git push origin main

3. Vercel Configuration (new project)
   Setting Value
      Framework Preset Other
         Build Command flutter build web --release --dart-define=API_URL=https://autolab-api.vercel.app
            Output Directory build/web
               Install Command Off
                  Development Command Off
                     Root Directory apps/customer_app
                     