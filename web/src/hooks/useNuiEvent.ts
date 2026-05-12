import React from 'react';

type NuiMessage<T> = {
	action: string;
	data: T;
};

export function useNuiEvent<T>(action: string, handler: (payload: T) => void) {
	const handlerRef = React.useRef(handler);

	React.useEffect(() => {
		handlerRef.current = handler;
	}, [handler]);

	React.useEffect(() => {
		const listener = (event: MessageEvent<NuiMessage<T>>) => {
			if (!event.data || event.data.action !== action) {
				return;
			}

			handlerRef.current(event.data.data);
		};

		window.addEventListener('message', listener);

		return () => {
			window.removeEventListener('message', listener);
		};
	}, [action]);
}
