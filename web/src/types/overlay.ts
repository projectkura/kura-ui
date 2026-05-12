export type OverlayAnchor =
	| 'top-left'
	| 'top-center'
	| 'top-right'
	| 'center-left'
	| 'center'
	| 'center-right'
	| 'bottom-left'
	| 'bottom-center'
	| 'bottom-right';

export type OverlayLayer = 'hud' | 'dialog';

export type ControlsOrientation = 'row' | 'column';

export type ControlsItem = {
	input: string;
	label: string;
};

export type ControlsPayload = {
	orientation: ControlsOrientation;
	items: ControlsItem[];
};

export type OverlayNode = {
	key: string;
	owner: string;
	feature: 'controls';
	id: string;
	layer: OverlayLayer;
	anchor: OverlayAnchor;
	offset: {
		x: number;
		y: number;
	};
	order: number;
	sequence: number;
	payload: ControlsPayload;
};

export type OverlayRemovePayload = {
	key: string;
};

export type OverlayClearOwnerPayload = {
	owner: string;
};
