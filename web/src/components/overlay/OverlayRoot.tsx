import ControlsOverlay from '../../features/controls/ControlsOverlay';
import type { OverlayAnchor, OverlayNode } from '../../types/overlay';
import AnchorLayer from './AnchorLayer';

type OverlayRootProps = {
	nodes: OverlayNode[];
};

const anchors: OverlayAnchor[] = [
	'top-left',
	'top-center',
	'top-right',
	'center-left',
	'center',
	'center-right',
	'bottom-left',
	'bottom-center',
	'bottom-right',
];

export default function OverlayRoot({ nodes }: OverlayRootProps) {
	const hudNodes = nodes.filter((node) => node.layer === 'hud');

	return (
		<div className="kura-ui-root pointer-events-none fixed inset-0 overflow-hidden">
			<div className="pointer-events-none absolute inset-0">
				{anchors.map((anchor) => {
					const anchorNodes = hudNodes.filter((node) => node.anchor === anchor);

					if (anchorNodes.length === 0) {
						return null;
					}

					return (
						<AnchorLayer key={anchor} anchor={anchor}>
							{anchorNodes.map((node) => (
								<ControlsOverlay key={node.key} node={node} />
							))}
						</AnchorLayer>
					);
				})}
			</div>
		</div>
	);
}
