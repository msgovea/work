package com.ciandt.talentos.gconf.backend.dto;

import com.ciandt.talentos.gconf.backend.entities.Palestrante;

public class PalestranteDTO {

	private Long id;
	private String nome;
	private String titulo;
	private String email;
	private String biografia;
		
	
	public PalestranteDTO() {}
	
	public PalestranteDTO(Palestrante entity) {
		this.id = entity.getId();
		this.nome = entity.getNome();
		this.titulo = entity.getTitulo();
		this.email = entity.getEmail();
		this.biografia = entity.getBiografia();
	}
	
	public Palestrante toEntity() {
		return new Palestrante(
				this.getId(),
				this.getNome(),
				this.getTitulo(),
				this.getEmail(),
				this.getBiografia());
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNome() {
		return nome;
	}

	public void setNome(String nome) {
		this.nome = nome;
	}

	public String getTitulo() {
		return titulo;
	}

	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getBiografia() {
		return biografia;
	}

	public void setBiografia(String biografia) {
		this.biografia = biografia;
	}
	
	
	
}
