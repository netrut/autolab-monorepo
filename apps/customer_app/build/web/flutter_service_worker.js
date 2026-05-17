'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"manifest.json": "b07f5793c9de7bd04affd8bb5feff1ec",
"version.json": "ddf983dc637227d649281a4aeca498f0",
"flutter_bootstrap.js": "2456be9dc339cb18b1ca5ffbd92e8ba8",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"main.dart.js": "f3ed519de96e34d86d34b6a436c47387",
"assets/AssetManifest.bin": "51837fcc9750cd4c9e6815424ccf583a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/AssetManifest.bin.json": "31c4090b388af5c2c7021aa696f73343",
"assets/AssetManifest.json": "a84451c3db60b09598f5413efd47db57",
"assets/NOTICES": "ab1d677dba8ea80e9a4b573c3a55f2f8",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/MaterialIcons-Regular.otf": "2f7de439e5e560c1a5f8ba70828ae45d",
"assets/FontManifest.json": "28b77b7e87ff3a719e667438e04d7bdd",
"assets/assets/images/two-wheeler.png": "6da390b614dcc90f9ac937011ecdcd8f",
"assets/assets/images/bike.png": "d974ad204e325bdd61cb7537ff5c3f6d",
"assets/assets/images/app_launcher_icon.png": "2e499a810d715571212fd35de1013510",
"assets/assets/images/home_4.png": "62f3da8c698c87748232ef4c5ed35539",
"assets/assets/images/home1.png": "f48f14e10c3a2e86c89c9e30086b7b21",
"assets/assets/images/next_service.png": "f93ca158e447bf04a9abb2979107a901",
"assets/assets/images/carApp.png": "5291740c43eb63146ec0c7c906ce3deb",
"assets/assets/images/carApp1.png": "e5dcd92612717d8d94ab742281fa0513",
"assets/assets/images/due-services.png": "b4b07d1c60ad9425b251a5fe569b4457",
"assets/assets/images/home_3.png": "9d2546fef738bf8b8824d32703c66c5f",
"assets/assets/images/AutoLabLogo.png": "2e499a810d715571212fd35de1013510",
"assets/assets/images/carApp2.png": "531e7255f66a9e44bafe72d3dcf18c1d",
"assets/assets/images/service_update_img.png": "75a75d7046a3c71dc2835b99988df140",
"assets/assets/images/contact-us.png": "d7a6ae5b2a78176d60ad9509981995f8",
"assets/assets/images/due_service.png": "1144e8bcbd14555313052046b2342677",
"assets/assets/images/carContact.png": "a74b598b815e2d7c0e112dc3b219859a",
"assets/assets/images/car11.png": "af3e2877c1d884e15b2c8ded2eec8535",
"assets/assets/images/header-car.png": "9e5d2b5f27967671cbc29c689683d71d",
"assets/assets/images/four-wheeler.png": "062c2ff00396b123eb5cb9d1e8953613",
"assets/assets/images/favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/assets/images/home2.png": "ee03eec1176340e2df981b35547030be",
"assets/assets/images/next-services.png": "821e5d41ebfdc1193a41082b50c3de5c",
"assets/assets/images/home2_1.png": "f107970df1cbf9a952fd339c78e71461",
"assets/assets/fonts/InterTight-Regular.ttf": "a199e0eb3432e76439e92218dba674d2",
"assets/assets/fonts/Poppins-Bold.ttf": "124cd57d8f41f6db22a724f882dca3f4",
"assets/assets/fonts/Poppins-SemiBold.ttf": "0fc985df77c6b59d37e79b97ed7fb744",
"assets/assets/fonts/Poppins-Regular.ttf": "07502c4fe46025097dd8b1e331182ee0",
"assets/assets/fonts/Poppins-Medium.ttf": "614a91afc751f09d049231f828801c20",
"assets/assets/fonts/InterTight-Bold.ttf": "d47ba303a1e845d1fe4d7872dfa91677",
"assets/assets/fonts/InterTight-SemiBold.ttf": "27b96747076190229e7a9598601b6c83",
"assets/assets/fonts/Poppins-Italic.ttf": "cd6b896a19b4babd1a2fa07498e9fc47",
"assets/assets/fonts/InterTight-Medium.ttf": "f099d2933b2bd7850e3eca4824efa6c8",
"index.html": "a65ddb5b192b47e07eb46e214f1a489f",
"/": "a65ddb5b192b47e07eb46e214f1a489f"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
