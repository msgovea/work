package com.ciandt.talentos.gconf.backend.controllers;

import java.util.List;
import java.util.stream.Collectors;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.ciandt.talentos.gconf.backend.dto.ConferenciaDTO;
import com.ciandt.talentos.gconf.backend.entities.Conferencia;
import com.ciandt.talentos.gconf.backend.services.ConferenciaService;


@Controller
public class ConferenciaController {
	
private final Logger log = Logger.getLogger(this.getClass());
	
	@Autowired
	private ConferenciaService conferenciaService;

    @ResponseBody
    @ResponseStatus(HttpStatus.OK)
    @RequestMapping(value="/conferencia/titulo/{titulo}", method = RequestMethod.GET)
  
    public List<ConferenciaDTO> searchConferenciasByTitulo(@PathVariable(value = "titulo") String titulo) {
    	
    	log.info("buscar Palestras por Titulo: " + titulo);
    	List<Conferencia> conferencias = conferenciaService.findConferenciasByTituloContainingIgnoreCase(titulo);
    	    	
    	return conferencias.stream()
    			.map(conferencia -> new ConferenciaDTO(conferencia))
    			.collect(Collectors.toList()); 
   }

}
