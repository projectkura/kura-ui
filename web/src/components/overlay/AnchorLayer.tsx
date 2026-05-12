import type { ReactNode } from 'react';
import { cn } from '../../lib/cn';
import type { OverlayAnchor } from '../../types/overlay';

type AnchorLayerProps = {
	anchor: OverlayAnchor;
	children: ReactNode;
};

const anchorClasses: Record<OverlayAnchor, string> = {
	'top-left':
		'top-[var(--overlay-edge-y)] left-[var(--overlay-edge-x)] items-start',
	'top-center':
		'top-[var(--overlay-edge-y)] left-1/2 -translate-x-1/2 items-center',
	'top-right':
		'top-[var(--overlay-edge-y)] right-[var(--overlay-edge-x)] items-end',
	'center-left':
		'top-1/2 left-[var(--overlay-edge-x)] -translate-y-1/2 items-start',
	center: 'top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 items-center',
	'center-right':
		'top-1/2 right-[var(--overlay-edge-x)] -translate-y-1/2 items-end',
	'bottom-left':
		'bottom-[var(--overlay-edge-y)] left-[var(--overlay-edge-x)] items-start',
	'bottom-center':
		'bottom-[var(--overlay-edge-y)] left-1/2 -translate-x-1/2 items-center',
	'bottom-right':
		'bottom-[var(--overlay-edge-y)] right-[var(--overlay-edge-x)] items-end',
};

const stackClasses: Record<OverlayAnchor, string> = {
	'top-left': 'flex-col',
	'top-center': 'flex-col',
	'top-right': 'flex-col',
	'center-left': 'flex-col',
	center: 'flex-col',
	'center-right': 'flex-col',
	'bottom-left': 'flex-col-reverse',
	'bottom-center': 'flex-col-reverse',
	'bottom-right': 'flex-col-reverse',
};

export default function AnchorLayer({ anchor, children }: AnchorLayerProps) {
	return (
		<div
			className={cn(
				'absolute flex gap-3',
				anchorClasses[anchor],
				stackClasses[anchor],
			)}
		>
			{children}
		</div>
	);
}
