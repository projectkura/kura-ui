import '@fontsource-variable/instrument-sans';
import '@fontsource/jetbrains-mono';
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './styles/app.css';

const rootElement = document.getElementById('root');

if (!rootElement) {
	throw new Error('kura-ui root element was not found.');
}

ReactDOM.createRoot(rootElement).render(
	<React.StrictMode>
		<App />
	</React.StrictMode>,
);
