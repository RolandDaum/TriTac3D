'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "bddb76156b38f870fa717763ddc1603e",
".git/config": "080a4c76e0cba8afdc8fb3850637a708",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/FETCH_HEAD": "fff9144572d57af1f5cc3f82e8176e68",
".git/HEAD": "7f573054fea1f948d1771058aad9d459",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "6dfa2e9ccd5b6aceaa621a76e70b579d",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "c8c09d29af2273efc109c3820b00aae6",
".git/logs/refs/heads/host": "8792b98c1a52867103a3d8a232178292",
".git/logs/refs/heads/main": "0e98dd02db50269226071062b3745478",
".git/logs/refs/remotes/origin/HEAD": "0e98dd02db50269226071062b3745478",
".git/logs/refs/remotes/origin/host": "a16874fba757b536b15604d09e15d9cd",
".git/objects/08/a2c251b148c69a2219afb8e86ca3df050afddf": "0671062be6773854c241400c968d2793",
".git/objects/23/9d256efa68632d29e3fe3dd0391b2115a8175d": "f860ba119103ce6b74d4869c8e6f3b2c",
".git/objects/28/bc5c9234dc353bc04e94dba3a563281bac7f6a": "375d6b767f04c88f11e4114dbdcfaf50",
".git/objects/2a/6edcd1eba375bfbad00208509d5ab23beabcf3": "77cb7926ecca05d0a4ffe6ddb85dc690",
".git/objects/3a/8826d313060640e5ed2e06ccc7fef4ca250684": "1cb392f655f97aae70df0c9e62eff371",
".git/objects/45/570a4b18fe6cdcef984131a44ccbf0dbee5842": "ca73eb7d3010931f45d3c8a156f5a285",
".git/objects/48/1e97df40d9b54f88e404420956ede1faee42db": "063382f63673f4e22ff54ed578405fe6",
".git/objects/57/b64801e7d6151db5e6b3eeeae478ec2c75f972": "060871930ad3a05a19c470c06c8ad644",
".git/objects/5f/1a92756215f80756b80d7bb8b485301c233a38": "123f706aec1bdfabf3d0759932764605",
".git/objects/74/83c0f707a84cdfc2091ff9932d1f39a784edc1": "717b8d05ac989364b9dd80147f993af0",
".git/objects/77/4481b0c08b7ae7f203539ca371a6857c465113": "d5ffd62ddd2530fbefb97a5bb6d37b22",
".git/objects/7a/8ee5b160cce588d1e06addffc259e3a238eb8f": "583bbb0d79c52b2b48155c733b3851c5",
".git/objects/96/62561748f3ee880c3e33ade4f21772f8d3f941": "4a81b5efc684cc8555e22a2170bf9fa3",
".git/objects/9d/b89eb4b8e1edcb1b42d497ce188feccdfa0740": "950c6b46cd52d54de2e68e09c9b24319",
".git/objects/a6/93e5a5e50c1697ec99e79137e7a8d73a00c1d2": "71756b766b3947fd4b067595fccd13e4",
".git/objects/c7/5d0e5d5ff7016ee80dd4d96ee80f8bcdd4d23d": "4c6a37b288d743d55b61c25b1bc7b715",
".git/objects/cb/79d442c3319bd832a43bf6a122edbb4c463578": "f7ab9b5787b4b86536aa15a970dd8d41",
".git/objects/d5/041436055e5af95ac7343116c46ac78d9aa08b": "0efdf89284e32c1d31504c10bedc951e",
".git/objects/dd/7d2bd8c9e6acaa3c55c531f068bc5bb0c35e21": "625c47a433b2166a5d5bb5992c1e7a4d",
".git/objects/e0/bd25cb51ac82f9b0685ed5d1db0af0ea5c5e6b": "9b6fba955ac9d245d31ae8cdb6363635",
".git/objects/f9/228a294a53ab92c72302666910e1d95c14c1be": "88dff92ae66b09bf1e8df6bb7d97444b",
".git/objects/fc/6d1c7e3fe84358303b81e5118b5adb348b3c81": "35c09385243c740fa5dc13c692f3cd9e",
".git/objects/pack/pack-3c29969b926aa41e2e98f6e4abd3588700eb2a5a.idx": "54e150e2e86448736fef69c595700d36",
".git/objects/pack/pack-3c29969b926aa41e2e98f6e4abd3588700eb2a5a.pack": "d56bb0a31a11470016100596fe6368d9",
".git/objects/pack/pack-3c29969b926aa41e2e98f6e4abd3588700eb2a5a.rev": "ad858d17ba7c64491105d49c2b8880b4",
".git/ORIG_HEAD": "7a08b380abd950d75386d8cd61ea75d6",
".git/packed-refs": "3249800827c4312b4342c37fa167543e",
".git/refs/heads/host": "7a08b380abd950d75386d8cd61ea75d6",
".git/refs/heads/main": "0aeee0f271ba5757b9453451a503f1bd",
".git/refs/remotes/origin/HEAD": "98b16e0b650190870f1b40bc8f4aec4e",
".git/refs/remotes/origin/host": "7a08b380abd950d75386d8cd61ea75d6",
".vscode/settings.json": "99285e8a87828c63eaa0cfc40c4de2f9",
"assets/AssetManifest.bin": "212ced7f4bc642b0f1de15c4c1fed8f9",
"assets/AssetManifest.bin.json": "488b07829abc1d36148a483617ed4c08",
"assets/AssetManifest.json": "ba8d6fb5da064d206e58e137fc4d1acb",
"assets/assets/fonts/Inter-Italic-VariableFont.ttf": "6dce17792107f0321537c2f1e9f12866",
"assets/assets/fonts/Inter-VariableFont.ttf": "0a77e23a8fdbe6caefd53cb04c26fabc",
"assets/assets/fonts/Inter_28pt-Black.ttf": "298c6ce1b2641dfe1647544180b67fd1",
"assets/assets/fonts/Jersey10-Regular.ttf": "ef3eda204f384e87bef55e9d4d6366f9",
"assets/assets/icons/icon_abc.svg": "6cbfdceb45eb95c1e674f577a94c1f37",
"assets/assets/icons/icon_addcircle.svg": "bee8695288b34e5cbd525f781a1a3e6d",
"assets/assets/icons/icon_arrowback.svg": "22e0d617aace6b1866429143a30cd8f0",
"assets/assets/icons/icon_arrowdown.svg": "7599d03d2b2bfffcef6351cdbae5578a",
"assets/assets/icons/icon_arrowup.svg": "b81b75d8543f089e01c0bad6b9cc5839",
"assets/assets/icons/icon_crown.svg": "a52c901b4f0724b5bdd4444221fb3246",
"assets/assets/icons/icon_grid.svg": "17c77838640cf20c0a51c08ff7c6cf89",
"assets/assets/icons/icon_internetsearch.svg": "3b5c9bee1655c830475755109d9bbdeb",
"assets/assets/icons/icon_lan.svg": "bc8b230cdace31f3e75b98468c9ecd20",
"assets/assets/icons/icon_server.svg": "95ec1f13f87a1be6c4b609b1e4a31b4b",
"assets/assets/images/image_background.png": "f0be3110df24208fca7803cb93e6730d",
"assets/FontManifest.json": "d5301d632d7ae343077b56cf78c911db",
"assets/NOTICES": "9103a798a03d44fe02ac4dfc5f218ed6",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"CNAME": "2bd1378dde2e44b4edf7ca22f266e906",
"favicon.ico": "e290304a88541e339d1e616a70a57223",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"flutter_bootstrap.js": "1c03963601db13117b26829a216bcc08",
"icons/apple-touch-icon.png": "6001ff2911282f6cf7f6a7d3f501dd1e",
"icons/icon-192-maskable.png": "5d983010102b9b4905a663c06d4adf64",
"icons/icon-192.png": "dc99a9ef2a730507c253f759ab6bfb1b",
"icons/icon-512-maskable.png": "25995435446aa19f8ae214b0c483fc5b",
"icons/icon-512.png": "38d5d522076bfc6eb1e49ee9568daf5a",
"index.html": "b89efcaac7ad8d2f617e429c7ca9b872",
"/": "b89efcaac7ad8d2f617e429c7ca9b872",
"main.dart.js": "fddb8c7bd4d740fa0c068b3e03c56816",
"manifest.json": "48f376cc6fe01aa7ab04966a2f2feca1",
"version.json": "377c326a3149934b2aa7366820d2a4ba"};
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
