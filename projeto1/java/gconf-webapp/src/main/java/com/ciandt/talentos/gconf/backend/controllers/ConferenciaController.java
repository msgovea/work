package com.ciandt.talentos.gconf.backend.controllers;


import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.ciandt.talentos.gconf.backend.dto.ConferenciaDTO;
import com.ciandt.talentos.gconf.backend.entities.Conferencia;
import com.ciandt.talentos.gconf.backend.services.ConferenciaService;

@Controller
public class ConferenciaController {

	@Autowired
	private ConferenciaService conferenciaService;
	
	//ContainingIgnoreCase

	@ResponseBody
	@ResponseStatus(HttpStatus.OK)
	@RequestMapping(value = "/conferencia/search",  method = RequestMethod.GET)
	
	public List<ConferenciaDTO> searchfindBySearchTerm(
			@RequestParam(value = "titulo", required = false) String titulo,
			@RequestParam(value = "organizador", required = false) String organizador,
			@RequestParam(value = "assunto", required = false) String assunto) {

		/*List<Conferencia> conferencias = conferenciaService.
				findConferenciaByTituloOrOrganizadorOrAssuntoContainingIgnoreCase(titulo, organizador, assunto);
*/
		List<Conferencia>  conferencias = conferenciaService.
				findBySearchTerm(titulo,organizador,assunto);
		
		System.out.println(titulo);
		System.out.println(organizador);
		System.out.println(assunto);
		
		return conferencias.stream()
				.map(conferencia -> new ConferenciaDTO(conferencia))
				.collect(Collectors.toList());
	}

	
	//commita logo
}