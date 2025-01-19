'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "89902f517cc2114d93761cc6a6589ebf",
".git/config": "080a4c76e0cba8afdc8fb3850637a708",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/FETCH_HEAD": "40db81eabfe9143a2af02a2de5edb06f",
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
".git/index": "07c4165c36abb840fe6829b998b21b5a",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "4a35a239a3e0fd4604dca211dea133e3",
".git/logs/refs/heads/host": "c02ae75d1e827278702f505b8fb3c5da",
".git/logs/refs/heads/main": "aa7a9548199fb7645759d23fc22f3992",
".git/logs/refs/remotes/origin/HEAD": "aa7a9548199fb7645759d23fc22f3992",
".git/logs/refs/remotes/origin/host": "e352f89d51a9b79ff2eab7feb3070323",
".git/objects/02/d379985de129bf1118143f9405993014d84a88": "49a3fd720a605cdff3cce75df2a0f8a8",
".git/objects/05/a9058f513cce5faf1704e06e3c150688b0a01f": "e8d02f60cf87abd4c1de4b153dd696dc",
".git/objects/06/5a156ad876ae75d08bca0aabc8c1e01f285abb": "1338ac20d12542d14345378e2fe2be26",
".git/objects/08/4ea6433e923e366224dacf8e0d29000eeff62c": "640fe9ce9e00c2ad91e97bbdbce46aff",
".git/objects/15/9f46f6643894aad08868df0a848fbf21cc2b12": "eec10bd9dad7b6cc37fde413e839bae3",
".git/objects/1f/3485ae5ddd2015642206ce9852060927e61045": "fcb1c5a8d03c37a3f78ef9add28ae9cc",
".git/objects/27/a297abdda86a3cbc2d04f0036af1e62ae008c7": "51d74211c02d96c368704b99da4022d5",
".git/objects/2d/0471ef9f12c9641643e7de6ebf25c440812b41": "d92fd35a211d5e9c566342a07818e99e",
".git/objects/34/9086409b60298bae253a0b1d3ae327387bfb64": "126aeebbcc921aeb4d400961e9f68bfd",
".git/objects/37/ea35ffffc3d9c1ced3ee7d3f75724cdaac3fc0": "05f029be9df7fc74ed00b612a196088b",
".git/objects/3b/a777f75f5dcb00534d616d4b1983efa40652ee": "ffbdf4e2c7266c1efe9c29bfbbceceaa",
".git/objects/3b/b0860a0981211a1ab11fced3e6dad7e9bc1834": "3f00fdcdb1bb283f5ce8fd548f00af7b",
".git/objects/3d/1437f2012c117a5281760cfc31877176bc9bd0": "77fa1ae1b7b80da7d3d3e38f43f9ce26",
".git/objects/46/456a14db41c2887b81513f36ce2f7203a434ff": "b01f9277dec90e011292912cfb0ec624",
".git/objects/5c/a4bc5534b886a9dbe578fc773dd73d51113766": "e798dc4320424e6476fd98ffad33e142",
".git/objects/63/6931bcaa0ab4c3ff63c22d54be8c048340177b": "8cc9c6021cbd64a862e0e47758619fb7",
".git/objects/6d/5f0fdc7ccbdf7d01fc607eb818f81a0165627e": "2b2403c52cb620129b4bbc62f12abd57",
".git/objects/73/7f149c855c9ccd61a5e24ce64783eaf921c709": "1d813736c393435d016c1bfc46a6a3a6",
".git/objects/75/98f7e28c1f0dc1487c16282d97904802980c1d": "04fcb02301cc157c5afcd2685cc62815",
".git/objects/7d/e64cb4c3d9e6bb08fbc3459b62a09fab81defe": "7a510fc6227964d205acadba16e3b50e",
".git/objects/8a/a4d096fec324131edd639c588af08b69d55d92": "9e31ce4c0e4f6fa05cc4391467deb294",
".git/objects/8c/59773bee8314a8ffb4431593d0fb49f52e34c6": "2eb993d30677573ffd0e58484cc6a514",
".git/objects/8e/576ced8edd90574e5ca0f759c83b286f00b599": "c5a517a81773a2dd548a8fd7e19f9faf",
".git/objects/97/8a4d89de1d1e20408919ec3f54f9bba275d66f": "dbaa9c6711faa6123b43ef2573bc1457",
".git/objects/9c/26fa133c3d50ead7edd35e05441a40351fbd12": "6a38a9bb89887f01465f1eaa08c6a4d7",
".git/objects/9f/77aeba9346f4f5b9ed6982239720912173dd4b": "3d24492a29650115c12640548fa10b0e",
".git/objects/a3/36414626af3fb0e6f66f87ba8b59748390c623": "bd3f1dbf6e29f37015a537ae3f0c11c2",
".git/objects/ad/29c04b972f768ce94cd08e7bd87594ae9bc7a3": "9ad7aff13526a259512a284b562a68ef",
".git/objects/af/30951a80725aa86531b723e7b9f899b8b5493a": "ae8f0f1a7c3b511bcd22ece2fe32dd19",
".git/objects/af/31ef4d98c006d9ada76f407195ad20570cc8e1": "a9d4d1360c77d67b4bb052383a3bdfd9",
".git/objects/b1/5ad935a6a00c2433c7fadad53602c1d0324365": "8f96f41fe1f2721c9e97d75caa004410",
".git/objects/b1/afd5429fbe3cc7a88b89f454006eb7b018849a": "e4c2e016668208ba57348269fcb46d7b",
".git/objects/b6/8a2f6a6362ba2a387a8d5abb7fd364b7d299a1": "10b1750f4f0bf50ee256fcc2bbc34410",
".git/objects/bf/1ee115e885ab9aa3be69aa29e0a8c5f0289397": "8ca9e36b0cb70119a4854a37a88fcc02",
".git/objects/c3/e81f822689e3b8c05262eec63e4769e0dea74c": "8c6432dca0ea3fdc0d215dcc05d00a66",
".git/objects/c5/6cdc91578593a83d13db83847ba36d51968b89": "ceabdec4a8f25d6b34579ec94075b7db",
".git/objects/c6/06caa16378473a4bb9e8807b6f43e69acf30ad": "ed187e1b169337b5fbbce611844136c6",
".git/objects/c7/7663172ca915a99a594ca17d06f527db05657d": "6335b074b18eb4ebe51f3a2c609a6ecc",
".git/objects/cb/5d0e6a9aa702a1904b6b0ec3b87265e98a9e3d": "d0499d0730204b29cf2dbe5e0f4e18b8",
".git/objects/ce/01965ab7de4439591731ff357beaa222461877": "ebab11d13276cdfc073f995dce20d7c0",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/de/dadf92e53b2497beeebe435cf374969f21a6c9": "13f5aa5a5ca443a457b0134d1bca5af6",
".git/objects/df/996c689b0d5b5b1dd6ffe19a360b63303345cf": "c98a251d6c5b62b587c17f9cedb332fe",
".git/objects/e8/3d1c4c4a6ba0037921b482fa28e5c21ac0812c": "2e54c9d78c71168aa780bdf50845d75f",
".git/objects/e9/d76ea1407c5ba84cb8af168bd339a82b73596e": "85b3e041123b73f21f439c604ec58bb2",
".git/objects/ec/361605e9e785c47c62dd46a67f9c352731226b": "d1eafaea77b21719d7c450bcf18236d6",
".git/objects/ef/b9b4361028bb894635b049512d10be6b88d40e": "60f20cb8e73fd9819bcbd137541e3857",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f2/e3502f5a1b2d8638435338e122578b8deab7ad": "3e2ba1623d68a121f0338c2b24bd41c1",
".git/objects/f6/269129b940b70f43f6fa0861931bc80dff80c4": "c9da9aa065318def8f3950183ad69c54",
".git/objects/pack/pack-0db58dd411597895585710ad0f7cba1292870121.idx": "87c17609932eb0b8c13bd3640c7356df",
".git/objects/pack/pack-0db58dd411597895585710ad0f7cba1292870121.pack": "3f0fbdcc7046f479143deb904f03c089",
".git/objects/pack/pack-0db58dd411597895585710ad0f7cba1292870121.rev": "05dcf773e89eed5bf586c5c97ed6ff94",
".git/ORIG_HEAD": "0716b6c4171563673a345f26a9cc166c",
".git/packed-refs": "1b418451d6665b974812211a4a325ad2",
".git/refs/heads/host": "0716b6c4171563673a345f26a9cc166c",
".git/refs/heads/main": "a6a9d0c0ef795d6bb8485eb9c9078675",
".git/refs/remotes/origin/HEAD": "98b16e0b650190870f1b40bc8f4aec4e",
".git/refs/remotes/origin/host": "0716b6c4171563673a345f26a9cc166c",
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
"assets/NOTICES": "ecc6455cfad6905627615f3775826384",
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
"favicon.ico": "e290304a88541e339d1e616a70a57223",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"flutter_bootstrap.js": "dd2fea5444991faa7127688a9273421a",
"icons/apple-touch-icon.png": "6001ff2911282f6cf7f6a7d3f501dd1e",
"icons/icon-192-maskable.png": "5d983010102b9b4905a663c06d4adf64",
"icons/icon-192.png": "dc99a9ef2a730507c253f759ab6bfb1b",
"icons/icon-512-maskable.png": "25995435446aa19f8ae214b0c483fc5b",
"icons/icon-512.png": "38d5d522076bfc6eb1e49ee9568daf5a",
"index.html": "b89efcaac7ad8d2f617e429c7ca9b872",
"/": "b89efcaac7ad8d2f617e429c7ca9b872",
"main.dart.js": "6629ca27e015d48b5df3d4f9816ec1f8",
"manifest.json": "48f376cc6fe01aa7ab04966a2f2feca1",
"privacypolicy/index.html": "039a30f3da554db71e17a8c26632ea82",
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
