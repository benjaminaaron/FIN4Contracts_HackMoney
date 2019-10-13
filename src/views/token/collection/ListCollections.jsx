import React from 'react';
import Box from '../../../components/Box';
import Table from '../../../components/Table';
import TableRow from '../../../components/TableRow';
import { drizzleConnect } from 'drizzle-react';
import { useTranslation } from 'react-i18next';
import PropTypes from 'prop-types';

function ListCollections(props) {
	const { t } = useTranslation();

	return (
		<Box title="Existing collections">
			<Table headers={['Identifier', 'Name', 'Description', 'Tokens count']}>
				{Object.keys(props.collections).map((identifier, index) => {
					let collection = props.collections[identifier];
					return (
						<TableRow
							key={'collection_' + index}
							data={{
								identifier: identifier,
								name: collection.name,
								description: <small>{collection.description}</small>,
								tokensCount: collection.tokensCount
							}}
						/>
					);
				})}
			</Table>
		</Box>
	);
}

ListCollections.contextTypes = {
	drizzle: PropTypes.object
};

const mapStateToProps = state => {
	return {
		collections: state.fin4Store.collections
	};
};

export default drizzleConnect(ListCollections, mapStateToProps);