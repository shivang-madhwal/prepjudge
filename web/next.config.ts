import type {NextConfig} from 'next';
const config: NextConfig={async rewrites(){return [{source:'/backend/:path*',destination:`${process.env.API_ORIGIN || 'http://127.0.0.1:8080'}/:path*`}];}};
export default config;
