{{flutter_js}}
{{flutter_build_config}}

const loading = document.createElement('div');

loading.style.width = '100svw';
loading.style.height = '100svh';
loading.style.margin = '0';
loading.style.padding = '0';
loading.style.display = 'flex';
loading.style.justifyContent = 'center';
loading.style.alignItems = 'center';

loading.innerHTML = `
    <style>
        .loader {
            width: 8rem;
            height: 8rem;
            animation: spin 2s ease-out infinite;
        }
        .loader img {
            width: 100%;
            height: 100%;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
    <div class="loader">
        <img src="icons/Icon-192.png" alt="loading-logo"/>
    </div>
`;
document.body.appendChild(loading);

_flutter.buildConfig.builds[0].mainJsPath += "?v=" + serviceWorkerVersion;

_flutter.loader.load({
    serviceWorkerSettings: {
        serviceWorkerVersion: serviceWorkerVersion
    },
    onEntrypointLoaded: async function(engineInitializer) {
        const appRunner = await engineInitializer.initializeEngine();
        await appRunner.runApp();
        document.body.removeChild(loading);
    },
});