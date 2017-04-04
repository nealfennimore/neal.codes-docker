import path from 'path';
import { isDevelopment } from './shared/env.js';
import buildVersion from './buildStamp.js';

const config = {
    server: {
        port: $APP_PORT,
        devPort: $APP_DEV_PORT,
        ip: '0.0.0.0',
        hostname: isDevelopment ? 'web' : '$HOST_NAME', // We ignore SSL in development mode
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
        VENDOR_SCSS: /vendor\.scss$/,
        IMAGE_FILES: /.*\.(gif|png|jpe?g|svg)$/i,
        PROJECT_IMAGE_FILES: /projects\/.*\.(gif|png|jpe?g|svg)$/i,
        FONT_FILES: /fonts\/.*\.(eot|svg|ttf|woff2?)(\?.*)?$/,
        FONT_STYLES: /fonts\/style\.scss$/
    },
    webpack: {
        cssModuleName: `[name]-[local]__${buildVersion.slice(0, 5)}`,
        hmrPath: '$APP_HMR_PATH'
    }
};

export default config;