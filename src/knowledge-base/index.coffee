import h from 'react-hyperscript'
import {Component} from 'react'
import update from 'immutability-helper'
import {StatefulComponent, APIContext,
        PagedAPIView, APIResultView} from '@macrostrat/ui-components'
import {InputGroup} from '@blueprintjs/core'
import './main.styl'

class KnowledgeBaseFilterView extends Component
  @contextType: APIContext
  constructor: (props)->
    super props
    @state = {
      doc_ids: []
      types: []
      filter: {}
      query: ""
    }

  updateState: (spec)=>
    newState = update @state, spec
    @setState newState

  renderExtractions: (response)=>
    console.log response
    {data} = response
    console.log data
    h 'div.results', data.map (i)->
      src = i.target_img_path.replace "img/", "/kb-images/"
      h 'div', [
        h 'img', {src}
        h 'p', i.target_unicode
        h 'p', i.assoc_unicode
      ]

  render: =>
    {query} = @state
    h 'div#knowledge-base-filter', [
      h 'h1', [
        'COSMOS ',
        h 'span.subtle', 'Knowledge base filter'
      ]
      @renderSearchbar()
      h PagedAPIView, {
        route: '/model/extraction'
        params: {query}
        topPagination: true
        bottomPagination: false
      }, @renderExtractions
    ]

  updateQuery: (event)=>
    {value} = event.target
    @updateState {query: {$set: value}}

  renderSearchbar: ->
    h InputGroup, {
      leftIcon: 'search'
      placeholder: "Search extractions"
      onChange: @updateQuery
    }

  getTypes: ->
    {doc_id} = @state.filter
    types = await get '/model/extraction-type', {doc_id}
    @setState {types}

  componentDidMount: ->
    {get} = @context

    doc_ids = await get '/model/document', {all: true}
    @setState {doc_ids}

  componentDidUpdate: (prevProps, prevState)->
    return if @state.filter.doc_id == prevState.filter.doc_id
    @getTypes()


export {KnowledgeBaseFilterView}
