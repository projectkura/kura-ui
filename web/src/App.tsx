import React from 'react';
import OverlayRoot from './components/overlay/OverlayRoot';
import { useNuiEvent } from './hooks/useNuiEvent';
import {
	initialOverlayState,
	type OverlayAction,
	overlayReducer,
} from './store/overlay-store';
import type {
	OverlayClearOwnerPayload,
	OverlayNode,
	OverlayRemovePayload,
} from './types/overlay';

export default function App() {
	const [state, dispatch] = React.useReducer(
		overlayReducer,
		initialOverlayState,
	);

	useNuiEvent<{ node: OverlayNode }>('overlay:upsert', (data) => {
		dispatch({
			type: 'upsertNode',
			node: data.node,
		});
	});

	useNuiEvent<OverlayRemovePayload>('overlay:remove', (data) => {
		dispatch({
			type: 'removeNode',
			key: data.key,
		});
	});

	useNuiEvent<OverlayClearOwnerPayload>('overlay:clearOwner', (data) => {
		dispatch({
			type: 'clearOwner',
			owner: data.owner,
		});
	});

	useNuiEvent('overlay:reset', () => {
		dispatch({
			type: 'resetAll',
		} satisfies OverlayAction);
	});

	return <OverlayRoot nodes={state.nodes} />;
}
