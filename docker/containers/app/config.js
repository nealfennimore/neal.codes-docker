import path from 'path';
import buildVersion from './buildStamp.js';

const config = {
    server: {
        port: $APP_PORT,
        devPort: $APP_DEV_PORT,
        ip: '0.0.0.0',
        hostname: '$HOST_NAME',
        protocol: 'https'
    },
    paths: {
        ROOT: path.resolve(__dirname),
        CLIENT: path.resolve(__dirname, 'client'),
        SERVER: path.resolve(__dirname, 'server'),
        PUBLIC: path.resolve(__dirname, 'public'),
        DEV: path.resolve(__dirname, 'dev')
    },
    regex: {
        VENDOR_FILES: /vendor\.(scss|css|js)$/,
        VENDOR_SCSS: /vendor\.scss$/
    },
    webpack: {
        cssModuleName: `[name]-[local]__${buildVersion}`,
        hmrPath: '$APP_HMR_PATH'
    }
};

export default config;