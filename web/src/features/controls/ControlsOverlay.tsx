import type { OverlayNode } from '../../types/overlay';
import ControlsSet from './ControlsSet';

type ControlsOverlayProps = {
	node: OverlayNode;
};

export default function ControlsOverlay({ node }: ControlsOverlayProps) {
	return (
		<div
			className="animate-overlay-in"
			style={{
				transform: `translate(${node.offset.x}px, ${node.offset.y}px)`,
			}}
		>
			<ControlsSet
				orientation={node.payload.orientation}
				items={node.payload.items}
			/>
		</div>
	);
}
