import type { OverlayNode } from '../types/overlay';

export type OverlayState = {
	nodes: OverlayNode[];
};

export type OverlayAction =
	| { type: 'upsertNode'; node: OverlayNode }
	| { type: 'removeNode'; key: string }
	| { type: 'clearOwner'; owner: string }
	| { type: 'resetAll' };

export const initialOverlayState: OverlayState = {
	nodes: [],
};

function sortNodes(nodes: OverlayNode[]) {
	return [...nodes].sort((left, right) => {
		if (left.order !== right.order) {
			return left.order - right.order;
		}

		return left.sequence - right.sequence;
	});
}

export function overlayReducer(
	state: OverlayState,
	action: OverlayAction,
): OverlayState {
	switch (action.type) {
		case 'upsertNode': {
			const nextNodes = state.nodes.filter(
				(node) => node.key !== action.node.key,
			);
			nextNodes.push(action.node);
			return {
				nodes: sortNodes(nextNodes),
			};
		}

		case 'removeNode':
			return {
				nodes: state.nodes.filter((node) => node.key !== action.key),
			};

		case 'clearOwner':
			return {
				nodes: state.nodes.filter((node) => node.owner !== action.owner),
			};

		case 'resetAll':
			return initialOverlayState;
	}
}
